ISA = {
    # R-type: rd, rs1, rs2
    "ADD":  {"fmt": "R", "opcode": 0b0110011, "funct3": 0b000, "funct7": 0b0000000},
    "SUB":  {"fmt": "R", "opcode": 0b0110011, "funct3": 0b000, "funct7": 0b0100000},
    "SLT":  {"fmt": "R", "opcode": 0b0110011, "funct3": 0b010, "funct7": 0b0000000},
    "XOR":  {"fmt": "R", "opcode": 0b0110011, "funct3": 0b100, "funct7": 0b0000000},
    "OR":   {"fmt": "R", "opcode": 0b0110011, "funct3": 0b110, "funct7": 0b0000000},  
    "AND":  {"fmt": "R", "opcode": 0b0110011, "funct3": 0b111, "funct7": 0b0000000}, 

    # I-type (ALU imm): rd, rs1, imm
    "ADDI": {"fmt": "I", "opcode": 0b0010011, "funct3": 0b000},
    "SLTI": {"fmt": "I", "opcode": 0b0010011, "funct3": 0b010}, 
    "XORI": {"fmt": "I", "opcode": 0b0010011, "funct3": 0b100}, 
    "ORI":  {"fmt": "I", "opcode": 0b0010011, "funct3": 0b110}, 
    "ANDI": {"fmt": "I", "opcode": 0b0010011, "funct3": 0b111}, 

    # I-type (load): rd, imm(rs1) 
    "LW":   {"fmt": "I", "opcode": 0b0000011, "funct3": 0b010},

    # S-type: rs2, imm(rs1)
    "SW":   {"fmt": "S", "opcode": 0b0100011, "funct3": 0b010},

    # B-type: rs1, rs2, offset
    "BEQ":  {"fmt": "B", "opcode": 0b1100011, "funct3": 0b000},
    "BNE":  {"fmt": "B", "opcode": 0b1100011, "funct3": 0b001},
    "BLT":  {"fmt": "B", "opcode": 0b1100011, "funct3": 0b100},
    "BGE":  {"fmt": "B", "opcode": 0b1100011, "funct3": 0b101},

    # J-type: rd, offset
    "JAL":  {"fmt": "J", "opcode": 0b1101111},

    # I-type (jump): rd, rs1, imm
    "JALR": {"fmt": "I", "opcode": 0b1100111, "funct3": 0b000},

    # U-type: rd, imm
    "LUI":   {"fmt": "U", "opcode": 0b0110111},
    "AUIPC": {"fmt": "U", "opcode": 0b0010111},
}

#Syntax rules: 
#Everything after // on a line is ignored
#Labels on the same line as instruction or before 
#Registers x0 to x31
#Immediates are decimals or hex {0x##}
#Mnemonics are case sensitive 

import sys

def strip_comment(line):
    comment = line.split('//')
    line = comment[0]
    return line


def pass_1(source_lines):
    symbol_table = {}
    cleaned = []
    address = 0

    for raw_line in source_lines:
        line = strip_comment(raw_line).strip()
        if not line: continue

        if ':' in line:
            label, rest = line.split(':')
            symbol_table[label.strip()] = address
            line = rest.strip()
            if not line: continue

        cleaned.append((address, line))
        address += 4

    return symbol_table, cleaned

def parse_reg(s): #Used to validate registers
    try:
        if not s.startswith('x'):
            raise ValueError(f'Unknow register: {s}')

        reg = int(s[1:])
    except (ValueError, KeyError):
        raise ValueError(f'Unknow register: {s}')

    if reg < 0 or reg >31:
        raise ValueError(f'Unknow register: {s}')

    return reg

def parse_imm(s, symbol_table):
    try: 
        try:
            imm = int(s,0)
        except (ValueError, KeyError):
            imm = symbol_table[s]
    except (ValueError, KeyError):
        raise ValueError(f"Undefined label: {s}")

    return imm

def parse_r(operands, symbol_table):
    if len(operands) != 3:
        raise ValueError('Invalid number of registers')

    rd  = parse_reg(operands[0])
    rs1 = parse_reg(operands[1])
    rs2 = parse_reg(operands[2])

    return {"rd": rd, "rs1": rs1, "rs2": rs2, "imm": None}

def parse_i(operands, symbol_table):
    if len(operands) != 3:
        raise ValueError('Invalid number of registers')

    rd  = parse_reg(operands[0])
    rs1 = parse_reg(operands[1])
    imm = parse_imm(operands[2], symbol_table)

    return {"rd": rd, "rs1": rs1, "rs2": None, "imm": imm}

def parse_s(operands, symbol_table):
    if len(operands) != 3:
        raise ValueError('Invalid number of registers')

    rs1 = parse_reg(operands[0])
    rs2 = parse_reg(operands[1])
    imm = parse_imm(operands[2], symbol_table)

    return {"rd": None, "rs1": rs1, "rs2": rs2, "imm": imm}

def parse_b(operands, symbol_table, current_addr):
    if len(operands) != 3:
        raise ValueError('Invalid number of registers')

    rs1 = parse_reg(operands[0])
    rs2 = parse_reg(operands[1])
    imm = parse_imm(operands[2], symbol_table) - current_addr

    return {"rd": None, "rs1": rs1, "rs2": rs2, "imm": imm}

def parse_j(operands, symbol_table, current_addr):
    if len(operands) != 2:
        raise ValueError('Invalid number of registers')

    rd = parse_reg(operands[0])
    imm = parse_imm(operands[1], symbol_table) - current_addr

    return {"rd": rd, "rs1": None, "rs2": None, "imm": imm}

def parse_u(operands, symbol_table):
    if len(operands) != 2:
        raise ValueError('Invalid number of registers')

    rd = parse_reg(operands[0])
    imm = parse_imm(operands[1], symbol_table)

    return {"rd": rd, "rs1": None, "rs2": None, "imm": imm}
    
PASSERS = {
    "R": parse_r,
    "I": parse_i,
    "S": parse_s,
    "B": parse_b,
    "U": parse_u,
    "J": parse_j
}

def parse_instruction(mnemonic, operands, symbol_table, current_addr):
    if mnemonic not in ISA:
        raise ValueError(f"Unknown instruction: {mnemonic}")

    fmt = ISA[mnemonic]['fmt']
    if fmt in ('B', 'J'):
            parser = PASSERS[fmt]
            fields = parser(operands, symbol_table, current_addr)
    else:
        parser = PASSERS[fmt]
        fields = parser(operands, symbol_table)

    return {**ISA[mnemonic], **fields, "mnemonic": mnemonic}

def encode_r(fields):
    funct7 = fields["funct7"]
    rs2    = fields["rs2"]
    rs1    = fields["rs1"]
    funct3 = fields["funct3"]
    rd     = fields["rd"]
    opcode = fields["opcode"]

    word = (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode
    return word

def encode_i(fields):
    imm    = fields["imm"] & 0xFFF
    rs1    = fields["rs1"]
    funct3 = fields["funct3"]
    rd     = fields["rd"]
    opcode = fields["opcode"]

    word = (imm << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode
    return word

def encode_u(fields):
    imm    = fields["imm"] & 0xFFFFF
    rd     = fields["rd"]
    opcode = fields["opcode"]

    word = (imm << 12) | (rd << 7) | opcode
    return word

def encode_s(fields):
    imm    = fields["imm"] & 0xFFF
    rs1    = fields["rs1"]
    funct3 = fields["funct3"]
    rs2    = fields["rs2"]
    opcode = fields["opcode"]

    word = ((imm >> 5 & 0x7F)  << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | ((imm & 0x1F) << 7) | opcode
    return word

def encode_b(fields):
    imm    = fields["imm"] & 0x1FFF
    rs1    = fields["rs1"]
    funct3 = fields["funct3"]
    rs2    = fields["rs2"]
    opcode = fields["opcode"]

    word = ((imm >> 12 & 0x1)  << 31) | ((imm >> 5 & 0x3F) << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |((imm >> 1 & 0xF) << 8) | ((imm >> 11 & 0x1) << 7) | opcode
    return word

def encode_j(fields):
    imm    = fields["imm"] & 0x1FFFFF
    rd     = fields["rd"]
    opcode = fields["opcode"]

    word = ((imm >> 20 & 0x1)  << 31) | ((imm >> 1 & 0x3FF) << 21)| (imm >> 11 & 0x1) << 20 | ((imm >> 12 & 0xFF) << 12) | (rd << 7)| opcode
    return word

ENCODERS = {
    "R": encode_r,
    "I": encode_i,
    "S": encode_s,
    "B": encode_b,
    "U": encode_u,
    "J": encode_j,
}

def encode_instructions(fields):
    return ENCODERS[fields['fmt']](fields)


def write_hex_file(words, filepath):
    with open(filepath, 'w') as f:
        for word in words:
            hex_line = f'{word:08x}'
            f.write(hex_line + '\n')

def assemble(source_path, output_path):
    with open(source_path, 'r') as f:
        source_lines = f.readlines()

    symbol_table, cleaned = pass_1(source_lines)
    encoded_word = []

    for addr, text in cleaned:
        mnemonic, rest = text.split(' ', 1)
        operands = [op.strip() for op in rest.split(',')]
        fields = parse_instruction(mnemonic, operands, symbol_table, addr)
        word = encode_instructions(fields)
        encoded_word.append(word)

    write_hex_file(encoded_word, output_path)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python assembler.py <input.asm> <output.hex>")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]
    assemble(input_path, output_path)
    print(f"Assembled {input_path} -> {output_path}")