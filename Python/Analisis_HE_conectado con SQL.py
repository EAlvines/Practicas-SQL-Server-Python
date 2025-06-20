##CONECTAR CON SQL
import pyodbc
import pandas as pd

# Configura tu conexión
server = 'LAPTOP-KHFUKF43\SQLEXPRESS'
database = 'PROY_RRHH'

# Conexión
conn = pyodbc.connect(
    f'DRIVER={{SQL Server}};'
    f'SERVER={server};'
    f'DATABASE={database};'
    'Trusted_Connection=yes;')

# Prueba de conexión
print("Conexión exitosa")

# Consulta SQL
query = """
SELECT 
    Área,
    SUM(Horas_Extras) AS Total_HHEE,
    ROUND(SUM(Horas_Extras * Tarifa_Hora), 2) AS Costo_Total
FROM HorasExtras_IBK
GROUP BY Área;
"""
# Ejecutar consulta y traer datos
df = pd.read_sql(query, conn)

# Mostrar los primeros resultados
print(df.head(10))

##VISUALIZACION MATPLOTLIP
import matplotlib.pyplot as plt
df['Costo_Total'] = df['Costo_Total'].round(1)
print(df.sort_values(by='Costo_Total', ascending=False)) 
#sort_values - similar a Order By

#GRAFICOS
plt.figure(figsize=(10,6))
plt.barh(df['Área'], df['Costo_Total'], color='pink') #barh es grafico de barras laterales
plt.xlabel('Costo Total en Soles')
plt.ylabel('Área')
plt.title('Costo Total de HHEE por Área')
plt.show()

print("Total general de HHEE:", df['Total_HHEE'].sum())
print("Costo total general:", df['Costo_Total'].sum().round(2))
print("Promedio de Costo Total:", df['Costo_Total'].mean().round(2))
