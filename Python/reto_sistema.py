#Mini menú interactivo con funciones

tareas = ["enviar reporte", "Revisar nómina", "actualizar DB"]

def saludar():
    print("Hola! bienvenid@ al sistema")

def mostrar_lista(tareas):
    print("Tareas del día:")
    for tarea in tareas:
        print("-", tarea)

def salir():
    print("Hasta luego")
    return False

def agregar(tareas):
    nueva_tarea = input("Agrega la nueva tarea: ")
    if nueva_tarea:
        tareas.append(nueva_tarea)
        print("Tarea agredgada")
    else:
        print("No se agregó ninguna tarea")

#menu
activo = True
while activo:
    print("\n menu de opciones: ")
    print("1. saludar")
    print("2. Ver tareas")
    print("3. Salir")
    print("4. Agregar tarea")
    opcion = input("Elige las opcion (1-4): ")
    if opcion == "1":
        saludar()
    elif opcion == "2":
        mostrar_lista(tareas)
    elif opcion == "3":
        salir()
    elif opcion == "4":
        agregar(tareas)
    else:
        print("Opcion no valida, otra vez")