import pandas as pd
import requests
import json
import matplotlib.pyplot as plt

# Constantes configuráveis
API_URL = 'https://api-comexstat.mdic.gov.br/general'
NCM = '33030010'  # Código NCM do produto
PAIS = 275  # Código do país de origem (França)
VIA = "01"  # Código da via de transporte (Navio)
ESTADO = 41  # Código do estado (São Paulo)
OUTPUT_CSV = 'dados_importacao.csv'

def buscar_dados():
    '''
    Realiza a requisição POST para a API do ComexStat e retorna os dados em formato JSON.
    Ignora a verificação SSL para evitar erros de certificado.

    Returns:
        pd.DataFrame: DataFrame com os dados extraídos.
    '''
    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json"
    }

    data = {
        "flow": "import",
        "monthDetail": True,
        "period": {
            "from": "2023-01",
            "to": "2023-10"
        },
        "filters": [
            {
                "filter": "country",
                "values": [PAIS]  
            },
            {
                "filter": "ncm",
                "values": [NCM]
            },
            {
                "filter": "state",
                "values": [ESTADO]
            },
            {
                "filter": "via",
                "values": [VIA]
            }
        ],
        "details": ["country", "state", "ncm"],
        "metrics": [
            "metricFOB",
            "metricKG"
        ]
    }

    try:
        response = requests.post(API_URL, headers=headers, data=json.dumps(data), verify=False)
        response.raise_for_status()  # Verificar se houve erro na requisição

        if response.status_code == 200:
            print("Requisição bem-sucedida!")
            list_json = response.json()
            json_to_df = list_json['data']['list']  # Extrair a lista de dados

            # Convertendo os dados para um DataFrame do pandas
            df = pd.DataFrame(json_to_df)
            return df

        else:
            print(f"Erro: {response.status_code}")
            return None

    except requests.exceptions.RequestException as e:
        print(f"Erro ao fazer a requisição para a API: {e}")
        return None

def processar_dados(df):
    '''
    Processa os dados e adiciona a coluna "preco_por_kg" (FOB / KG).

    Args:
        df (pd.DataFrame): DataFrame com os dados brutos extraídos.

    Returns:
        pd.DataFrame: DataFrame filtrado e com os dados processados.
    '''
    if df is None or df.empty:
        print("Nenhum dado disponível para processar.")
        return pd.DataFrame()

    try:
        # Renomear colunas para facilitar o uso
        df.rename(columns={
            'coNcm': 'ncm', 
            'year': 'ano', 
            'monthNumber': 'mes', 
            'country': 'pais', 
            'state': 'estado', 
            'metricFOB': 'valor_fob', 
            'metricKG': 'quantidade_kg'
        }, inplace=True)

        # Converter 'valor_fob' e 'quantidade_kg' para numérico,
        df['valor_fob'] = pd.to_numeric(df['valor_fob'], errors='coerce')
        df['quantidade_kg'] = pd.to_numeric(df['quantidade_kg'], errors='coerce')

        # Calcular o preço por KG (FOB / KG)
        df['preco_por_kg'] = df['valor_fob'] / df['quantidade_kg']
        
        # Selecionar as colunas necessárias
        df_filtered = df[['ncm', 'ano', 'mes', 'pais', 'estado', 'ncm', 'valor_fob', 'quantidade_kg', 'preco_por_kg']]

        return df_filtered

    except KeyError as e:
        print(f"Erro ao processar os dados: coluna não encontrada {e}")
        return pd.DataFrame()

def gerar_csv(df, output_file):
    '''
    Gera um arquivo CSV com os dados filtrados.

    Args:
        df (pd.DataFrame): DataFrame com os dados filtrados.
        output_file (str): Nome do arquivo CSV de saída.
    '''
    if df.empty:
        print("Nenhum dado disponível para salvar no CSV.")
    else:
        df.to_csv(output_file, index=False)
        print(f"Arquivo CSV gerado: {output_file}")

def criar_graficos(df):
    '''
    Cria gráficos de visualização a partir dos dados filtrados.

    Args:
        df (pd.DataFrame): DataFrame com os dados filtrados.
    '''
    if df.empty:
        print("Nenhum dado disponível para gerar gráficos.")
        return
    
    try:
        df_result = df.groupby('mes').agg({
            'preco_por_kg': 'mean'
        }).reset_index()

        # Criando o gráfico de preço médio por KG ao longo dos meses
        plt.figure(figsize=(10, 6))
        plt.plot(df_result['mes'], df_result['preco_por_kg'], marker='o')
        plt.title('Preço Médio por KG ao Longo dos Meses')
        plt.xlabel('Mês')
        plt.ylabel('Preço por KG (R$)')
        plt.grid(True)

        # Adicionando rótulos com 2 casas decimais em cada ponto do gráfico
        for i in range(len(df_result)):
            plt.text(df_result['mes'][i], df_result['preco_por_kg'][i], f'{df_result["preco_por_kg"][i]:.2f}', 
                     ha='center', va='bottom', fontsize=10)

        plt.show()
        
    except KeyError as e:
        print(f"Erro ao criar gráficos: coluna não encontrada {e}")

def executar_pipeline():
    '''
    Função principal que orquestra o download, processamento, geração de CSV e gráficos.
    '''
    # Passo 1: Buscar dados
    df_raw = buscar_dados()

    if df_raw is not None and not df_raw.empty:
        # Passo 2: Processar dados
        df_filtrado = processar_dados(df_raw)

        # Passo 3: Gerar CSV com dados filtrados
        gerar_csv(df_filtrado, OUTPUT_CSV)

        # Passo 4: Criar gráficos
        criar_graficos(df_filtrado)
    else:
        print("Erro ao carregar os dados brutos.")

if __name__ == "__main__":
    executar_pipeline()
