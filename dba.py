import numpy as np

# variables inicales.
lamb = 50
num_onu = 20                # Cantidad de ONUs
ancho_banda_total = 2488.0  # Según ancho de banda por cable GPON 2.488 Gb/s de downstream
lat_min = 20.0              # Latencia minima
lat_max = 100.0             # Latencia maxima


def dba():
    demandas_onu = np.random.uniform(20, 600, num_onu)
    posicion_max = np.argmax(demandas_onu) + 1  # para saber cual ONU es la que tiene mayor demanda, por lo que esta presenta mayor congestión
    # Imprimir demandas de las ONU/ONT
    print("Demandas de las ONU/ONT (Mbps):", demandas_onu)
    print("ONU con mayor demanda:", posicion_max)
    demanda_total = np.sum(demandas_onu)

    if demanda_total > ancho_banda_total:
        variacion = np.random.uniform(0.5, 1.5, num_onu) # variable hecha para variar las asignaciones, en pos de simular medidas hechas por la OLT para asignar el ancho de banda
        asignaciones = (demandas_onu / demanda_total) * ancho_banda_total * variacion
        asignaciones = (asignaciones / np.sum(asignaciones)) * ancho_banda_total
    else:
        asignaciones = demandas_onu

    print("Asignaciones de ancho de banda (Mbps):", asignaciones)
    print("Suma de las asignaciones:", np.sum(asignaciones).round(3))
    latencias = (demandas_onu / asignaciones) * lat_min # calculo de latencias
    print("Latencia cada ONU:", latencias)








def schedule_a(val,t_a):
    #se agrega el nuevo elemento de calendarización
    t_a.append(val)
    t_a.sort()


def InputEvent(t_a):
    a = np.random.exponential(lamb)
    #dba()

def simulacion():
    t_a = []
    t_a.append(np.random.exponential(lamb))