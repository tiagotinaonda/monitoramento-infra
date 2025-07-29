import pandas as pd

# Caminho do arquivo de entrada e saída
input_file = "export.txt"
output_file = "export.xlsx"

# Leitura e preparação
with open(input_file, 'r', encoding='utf-8') as file:
    lines = file.readlines()

records = []
record = {}

for line in lines:
    line = line.strip()
    if not line:
        if record:
            records.append(record)
            record = {}
        continue
    if ":" in line:
        key, value = line.split(":", 1)
        record[key.strip()] = value.strip()

# Adiciona o último registro (caso o arquivo não termine com linha em branco)
if record:
    records.append(record)

# Cria DataFrame e exporta para Excel
df = pd.DataFrame(records)
df.to_excel(output_file, index=False)

print(f"Arquivo Excel gerado: {output_file}")
