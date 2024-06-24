import numpy as np
import matplotlib.pyplot as plt


# Variables iniciales.
lamb = 1/300
num_onu = 15                # Cantidad de ONUs
ancho_banda_total = 2488.0  # Según ancho de banda por cable GPON 2.488 Gb/s de downstream
lat_min = 20.0              # Latencia mínima
lat_max = 100.0             # Latencia máxima
utility = np.zeros(num_onu, dtype=int)
tasa_exito = np.zeros(num_onu, dtype=int)

mu = np.log(300**2 / np.sqrt(150**2 + 300**2))
sigma = np.sqrt(np.log(1 + (150**2 / 300**2)))

def dba():
    demandas_onu = np.random.lognormal(mu, sigma, num_onu)
    posicion_max = np.argmax(demandas_onu)  # Para saber cuál ONU es la que tiene mayor demanda
    demanda_total = np.sum(demandas_onu)
    #print("Demandas de las ONU/ONT (Mbps):", demandas_onu)
    #print("ONU con mayor demanda:", posicion_max +1)
    if demanda_total > ancho_banda_total: 
        variacion = np.random.uniform(0.5, 1.5, num_onu)  # Variable para variar las asignaciones
        asignaciones = (demandas_onu / demanda_total) * ancho_banda_total * variacion
        asignaciones = (asignaciones / np.sum(asignaciones)) * ancho_banda_total
    else:
        asignaciones = demandas_onu

    #print("Asignaciones de ancho de banda (Mbps):", asignaciones)
    latencias = (demandas_onu / asignaciones) * lat_min # calculo de latencias
    #print("Latencia cada ONU:", latencias)

    # Manejo de utilidad de cada ONU dependiendo de la mayor demanda
    utility[posicion_max] += 1  # Sumar 1 al índice de mayor demanda
    return latencias

def schedule_a(val, t_a):
    # Se agrega el nuevo elemento de calendarización
    t_a.append(val)
    t_a.sort()

def InputEvent(t_a):
    a = np.random.exponential(lamb)
    schedule_a(t_a[0] + a, t_a)
    latencias = dba()
    i = 0
    for lat in latencias:
        if lat <= lat_max:
            tasa_exito[i] += 1
        i +=1
    t_a.pop(0)
    return latencias

def metricas(promedios_latencias):
    for onu in range(num_onu):
        plt.plot(promedios_latencias[:, onu], label=f'ONU {onu + 1}')
    plt.xlabel('latencia por llegadas/10')
    plt.ylabel('Latencia Promedio (ms)')
    plt.title('Latencia Promedio de cada ONU por Llegadas/10')
    plt.legend(loc='right')
    plt.show()

def simulacion():
    llegadas = 0
    t_a = []
    t_a.append(np.random.exponential(lamb))
    latencias_totales = np.zeros(num_onu)
    promedios_latencias = []
    while llegadas < 10**6:
        latencias = InputEvent(t_a)
        latencias_totales += latencias
        llegadas += 1
        if llegadas % 10**5 == 0:
            promedio_latencia = latencias_totales / 10**5
            promedios_latencias.append(promedio_latencia.copy())
            latencias_totales = np.zeros(num_onu)

    promedios_latencias = np.array(promedios_latencias)

    print("La ONU con mayor demanda es: ",np.argmax(utility)+1)
    print("La ONU con menor demanda es: ",np.argmin(utility)+1)
    print("Se muestra la lista por máximo de demanda por iteración de cada ONU: ",utility)
    print("La ONU con mayor tasa de éxito es: ",np.argmax(tasa_exito)+1)
    print("La ONU con menor tasa de éxito es: ",np.argmin(tasa_exito)+1)
    print("Se muestra la lista con las tasas de exito de cada ONU: ",tasa_exito)
    #metricas(promedios_latencias)


simulacion()
#dba()