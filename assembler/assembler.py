
import re

# Define the instruction set based on the provided data
INSTRUCTION_SET = {
    'JADDR': '0100',
    'NOP': '0000000',
    'HLT': '0000001',
    'SETC': '0000010',
    'IN': '0000011',
    'OUT': '0000100',
    'MOV': '0001000',
    'INC': '0001001',
    'NOT': '0001010',
    'ADD': '0001011',
    'SUB': '0001100',
    'AND': '0001101',
    'IADD': '1010000',
    'LDM': '1010001',
    'LDD': '1010010',
    'STD': '1010011',
    'PUSH': '0010100',
    'POP': '0010101',
    'JZ': '0011000',
    'JN': '0011001',
    'JC': '0011010',
    'JMP': '0011011',
    'CALL': '0011100',
    'RET': '0011101',
    'INT': '1111110',
    'RTI': '0011111',
}

REGISTER_MAP = {
    'R0': '000',
    'R1': '001',
    'R2': '010',
    'R3': '011',
    'R4': '100',
    'R5': '101',
    'R6': '110',
    'R7': '111',
}

def read_assembly_file(filename):
    with open(filename, 'r') as file:
        instructions = file.readlines()

    assembled_instructions = []
    current_address = 0  

    for line in instructions:
        line = line.split('#')[0].strip()
        if not line:  # Skip empty lines
            continue
        
        if line.startswith('.ORG'):
            _, address = line.split()
            current_address = int(address, 16)  # Convert hex to decimal
        else:
            if line[0].isdigit():  
                jaddr_instruction = f"JADDR {line}"  
                assembled_instructions.append((current_address, jaddr_instruction))
                current_address += 1  
            else:
                
                assembled_instructions.append((current_address, line))
                if re.search(r',[0-9]', line):
                    current_address += 2
                else:
                    current_address += 1

    return assembled_instructions

def assemble_instruction(instruction, instruction_set, register_map):
    """Convert a single assembly instruction to binary."""
    # Split the instruction by spaces first
    parts = instruction.split()
    opcode = parts[0].strip().upper()

    if opcode not in instruction_set:
        raise ValueError(f"Unknown instruction: {opcode}")

    # Handle different types of instructions
    binary_instruction = instruction_set[opcode]

    if opcode in ['NOP', 'HLT', 'RET' , 'RTI','SETC']:
        # These instructions do not require registers
        return binary_instruction + '000000000'  

    elif opcode in ['ADD', 'SUB', 'AND']:
        # These instructions require three registers
        if len(parts) != 2:  # Expecting opcode and registers
            raise ValueError(f"Expected registers but only got opcode for {opcode}.")
        
        # Split the second part by commas to get the registers
        registers = parts[1].split(',')
        if len(registers) != 3:
            raise ValueError(f"Expected 3 registers for {opcode}, got {len(registers)}.")

        reg_dst = registers[0].strip().upper()
        reg_src1 = registers[1].strip().upper()
        reg_src2 = registers[2].strip().upper()

        if reg_dst not in register_map or reg_src1 not in register_map or reg_src2 not in register_map:
            raise ValueError(f"Unknown register: {reg_dst}, {reg_src1}, or {reg_src2}")

        return (binary_instruction + 
                register_map[reg_dst] + 
                register_map[reg_src1] + 
                register_map[reg_src2])  

    elif opcode=='IADD':
        # These instructions require one register and an immediate value or offset
        if len(parts) != 2:  # Expecting opcode and one register
            raise ValueError(f"Expected 2 register and a value but only got opcode for {opcode}")
        
        values = parts[1].split(',')
        if len(values) != 3:
            raise ValueError(f"Expected 2 register and a value for {opcode}, got {len(registers)}.")
        reg1=values[0].strip().upper()
        reg2 = values[1].strip().upper()
        imm=int(values[2].strip(),16)
        if reg1 not in register_map or reg2 not in register_map:
            raise ValueError(f"Unknown register: {reg_dst}")
        
        if(opcode == 'IADD'):
            instruction_line = binary_instruction + register_map[reg1] + register_map[reg2] + '000'
            immediate_line = format(imm & 0xFFFF, '016b')
            return instruction_line, immediate_line
        if(opcode == 'LDD'):
            instruction_line = binary_instruction + register_map[reg1] + register_map[reg2] + '000'
            immediate_line = format(imm & 0xFFFF, '016b')
            return instruction_line, immediate_line
        if(opcode == 'STD'):
            instruction_line = binary_instruction +  '000'+ register_map[reg1] + register_map[reg2] 
            immediate_line = format(imm & 0xFFFF, '016b')
            return instruction_line, immediate_line

    elif opcode in ['LDD', 'STD']:
        # Handle LDD and STD instructions
        if len(parts) != 2:  # Expecting opcode and one register
            raise ValueError(f"Expected 2 registers and an offset for {opcode}")
        
        values = parts[1].split(',')
        if len(values) != 2:
            raise ValueError(f"Expected 2 registers and an offset for {opcode}, got {len(values)}.")
        
        reg1 = values[0].strip().upper()  # Destination register
        offset_reg = values[1].strip().upper()  # Base register with offset

        # Parse the offset
        if '(' in offset_reg and ')' in offset_reg:
            # Extract the immediate value and base register
            offset_value = int(offset_reg.split('(')[0].strip(),16)
            base_reg = offset_reg.split('(')[1].strip(')')

            if base_reg not in register_map:
                raise ValueError(f"Unknown base register: {base_reg}")
        else:
            raise ValueError(f"Invalid format for offset in {opcode}: {offset_reg}")

        if reg1 not in register_map:
            raise ValueError(f"Unknown register: {reg1}")

        if opcode == 'LDD':
            instruction_line = (binary_instruction + register_map[reg1] +  register_map[base_reg] + '000')
            immediate_line = format(offset_value & 0xFFFF, '016b')  # Convert immediate to 16 bits
            return instruction_line, immediate_line  # Return both lines as a tuple
        
        elif opcode == 'STD':
            instruction_line = (binary_instruction + '000' + register_map[base_reg] + register_map[reg1])
            immediate_line = format(offset_value & 0xFFFF, '016b')
            return instruction_line, immediate_line  # Return both lines as a tuple

        
    elif opcode in ['IN', 'POP']:
        # These instructions require one register
        if len(parts) != 2:  # Expecting opcode and one register
            raise ValueError(f"Expected 1 register but got only opcode for {opcode}.")
        
        registers = parts[1].split(',')
        if len(registers) != 1:
            raise ValueError(f"Expected 1 register for {opcode}, got {len(registers)}.")

        reg_dst = registers[0].strip().upper()
        if reg_dst not in register_map:
            raise ValueError(f"Unknown register: {reg_dst}")

        return binary_instruction + register_map[reg_dst] + '000000'  # Padding for 6 bits

    elif opcode in ['JZ', 'JN', 'JC', 'JMP', 'CALL', 'PUSH', 'OUT']:
        if len(parts) != 2:  # Expecting opcode and one register
            raise ValueError(f"Expected 1 register but got only opcode for {opcode}.")
        
        registers = parts[1].split(',')
        if len(registers) != 1:
            raise ValueError(f"Expected 1 register for {opcode}, got {len(registers)}.")

        reg_src1 = registers[0].strip().upper()
        if reg_src1 not in register_map:
            raise ValueError(f"Unknown register: {reg_src1}")
        return binary_instruction + '000' +register_map[reg_src1] + '000' 
    
    elif opcode in ['NOT', 'INC', 'MOV']:
        if len(parts) != 2:  # Expecting opcode and one register
            raise ValueError(f"Expected 2 register but got only opcode for {opcode}.")
        
        registers = parts[1].split(',')
        if len(registers) != 2:
            raise ValueError(f"Expected 2 register for {opcode}, got {len(registers)}.")

        reg_dst = registers[0].strip().upper()
        reg_src1 = registers[1].strip().upper()
        if reg_src1 not in register_map or reg_dst not in register_map:
            raise ValueError(f"Unknown register: {reg_src1}")
        return binary_instruction + register_map[reg_dst] +register_map[reg_src1] + '000'

    elif opcode =='LDM':
        # These instructions require one register and an immediate value or offset
        if len(parts) != 2:  # Expecting opcode and one register
            raise ValueError(f"Expected 1 register and a value but only got opcode for {opcode}")
        
        values = parts[1].split(',')
        if len(values) != 2:
            raise ValueError(f"Expected 1 register and a value for {opcode}, got {len(registers)}.")
        reg_dst=values[0].strip().upper()
        imm=int(values[1].strip(),16)
        if reg_dst not in register_map:
            raise ValueError(f"Unknown register: {reg_dst}")
        
        instruction_line = binary_instruction + register_map[reg_dst]+  '000'+  '000'
        immediate_line = format(imm & 0xFFFF, '016b')
        return instruction_line, immediate_line

    elif opcode =="INT":
        if len(parts) != 2:  # Expecting opcode and one register
            raise ValueError(f"Expected int value but got only opcode for {opcode}.")
        
        registers = parts[1].split(',')
        if len(registers) != 1:
            raise ValueError(f"Expected int value for {opcode}, got {len(registers)}.")

        reg_src1 = registers[0].strip().upper()
        if reg_src1 != '1' and reg_src1 != '0':
            raise ValueError(f"Unknown value for interrupt: {reg_src1}")
        return binary_instruction + '00000' +reg_src1 + '000' 

    elif opcode =="JADDR":
        if len(parts) != 2:  # Expecting opcode and one register
            raise ValueError(f"Expected immediate hexa address value but got only opcode for {opcode}.")
        
        registers = parts[1].split(',')
        if len(registers) != 1:
            raise ValueError(f"Expected int value for {opcode}, got {len(registers)}.")

        hexaddr = int(registers[0].strip(),16)
        jaddress=format(hexaddr, '012b')
        return binary_instruction + jaddress
    
    else:
        raise ValueError(f"Unhandled instruction format for: {opcode}")


def write_memory_file(binary_instructions, output_filename):
    """Write binary instructions to a memory file in reverse order, with special lines at the end."""
    with open(output_filename, 'w') as file:
        file.write("// memory data file (do not edit the following line - required for mem load use) \n")
        file.write("// instance=/cpu/Int_Mem/MEM \n")
        file.write("// format=mti addressradix=d dataradix=b version=1.0 wordsperline=1 \n")
        file.write("4095: 0000001000000000\n")  # Line 4
        instruction_map = {address: instruction for address, instruction in binary_instructions}

        # Write instructions in reverse order for addresses 4094 to 0
        for index in range(4094, -1, -1):
            if index in instruction_map:
                # Write the instruction from the instruction_map
                file.write(f"{index}: {instruction_map[index]}\n")
            else:
                file.write(f"{index}: 0000000000000000\n")  # Fill with 16 zeros if no instruction


def main(input_filename, output_filename):
    """Main function to assemble instructions."""
    assembled_instructions = read_assembly_file(input_filename)

    binary_instructions = []
    for address, instruction in assembled_instructions:
        binary_instruction = assemble_instruction(instruction, INSTRUCTION_SET, REGISTER_MAP)
        
        if isinstance(binary_instruction, tuple):
            instruction_line, immediate_line = binary_instruction
            binary_instructions.append((address, instruction_line))
            binary_instructions.append((address + 1, immediate_line))
        else:
            binary_instructions.append((address, binary_instruction))

    write_memory_file(binary_instructions, output_filename)
    print(f"Assembled {len(assembled_instructions)} instructions to {output_filename}")


main('input.asm', 'output.mem')