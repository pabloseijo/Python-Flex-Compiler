# Compilador Python con FLEX

## Descripción

Este proyecto contiene el código necesario para un compilador de Python, construido con la herramienta Flex para el análisis léxico. Incluye un analizador léxico y sintáctico, manejo de errores, y una tabla de símbolos. Es capaz de procesar, analizar y ejecutar código escrito en un subconjunto del lenguaje Python, enfocándose en las operaciones y estructuras más fundamentales. La utilización de Flex permite una implementación eficiente y flexible del análisis léxico, crucial para la interpretación correcta del código fuente.


## Estructura del Proyecto

El proyecto se divide en varias partes principales:

- **Analizador Léxico (`lex.yy.c`)**: Define el análisis léxico del compilador, identificando tokens dentro del código fuente.
- **Analizador Sintáctico (`analizadorSintactico.h` y archivos relacionados)**: Gestiona el análisis sintáctico, estructurando los tokens en construcciones del lenguaje.
- **Tabla de Símbolos (`tablaSimbolos.h` y `tablaHash.h`)**: Almacena y gestiona los identificadores y símbolos encontrados durante el análisis.
- **Manejo de Errores (`gestionErrores.h` y archivos relacionados)**: Proporciona mecanismos para reportar y manejar errores encontrados durante la compilación.
- **Pruebas y Ejemplos**: Incluye archivos de prueba y ejemplos para demostrar y validar las capacidades del compilador.

## Compilación del Proyecto

Para compilar este compilador de Python, se incluye un `Makefile` que automatiza el proceso de compilación utilizando `gcc`. Asegúrate de tener instalado `gcc` en tu sistema.

### Pasos para Compilar

1. Abre una terminal en el directorio donde se encuentra el `Makefile`.
2. Ejecuta el comando `make`.

Esto compilará los archivos fuente y generará el ejecutable `miCompilador` en el directorio `bin/`.

## Uso

Después de compilar, puedes ejecutar el compilador utilizando el siguiente comando en la terminal:

```
./bin/miCompilador wilcoxon.py
```

## Limpieza

Para limpiar el proyecto (eliminar archivos objeto y el ejecutable), ejecuta:
```
make clean
```