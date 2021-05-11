# ToonShaderBalls by Fabián Alfonso Beirutti Pérez
Toon shader balls sketch using GLSL on processing.

## Introducción
El objetivo de esta práctica de la asignatura de 4to, Creación de Interfaces de Usuario (CIU), es empezar a tratar los conceptos y las primitivas del tratamiento de sombras o *shaders*. Para ello, se ha pedido el desarrollo de una aplicación que haga uso de un *shader* de fragmentos, sugiriendo un diseño generativo o realice un algún procesamiento sobre imagen. Todo ello, usando el lenguaje de programación y el IDE llamado Processing. Este permite desarrollar código en diferentes lenguajes y/o modos, como puede ser processing (basado en Java), p5.js (librería de JavaScript), Python, entre otros.
<p align="center"><img src="/toonShaderBallsGif.gif" alt="Toon shader balls sketch using GLSL on processing"></img></p>

## Controles
Los controles de la aplicación se mostrarán en todo momento por pantalla para facilitar su uso al usuario:
- **Movimiento del ratón arriba-abajo:** Varía la distancia entre los píxels.
- **Movimiento del ratón derecha-izquierda:** Varía la intensidad de la luz.
- **Click izquierdo del ratón:** Activa el nuevo efecto de los *shaders* en cada bola.
- **Círculo selector de color #1:** Aplica el color seleccionado al efecto del *shader* que se produce al hacer click izquierdo con el ratón.
- **Tecla B:** Bloque el control del ratón (mantiene los últimos valores constantes).
- **Tecla C:** Cambia las bolas de posición.
- **Tecla H:** Muestra / esconde los selectores de color de las bolas.
- **Tecla ESC:** Cierre de la aplicación.

## Descripción
Aprovechando que el lenguaje de programación que utiliza el IDE Processing por defecto está basado en Java, podemos desarrollar nuestro código utilizando el paradigma de programación de "Programación Orientada a Objetos". Así pues, hemos descrito tres clases de Java:
- **ToonShaderBalls:** clase principal.
- **Ball:** clase que representa cada una de las bolas de color.
- **shaderBall.glsl:** fichero o clase que describe e implementa los efectos del *shader* sobre cada una de las bolas.

## Explicación
### Clase ToonShaderBalls
Esta es la clase principal de la aplicación, la cual gestiona la información mostrada por pantalla al usuario (interfaz gráfica), esto es, el desarrollo de los métodos setup() y draw().
```java
void setup() {
  size(1200, 800, P2D);
  numBalls = 5;
  menuNumBalls = 3;
  showColorSelector = false;
  blockMousePosition = true;
  menu = true;
  image = loadImage("Captura.JPG");
  initEffect();
  shaderBall = loadShader("shaderBall.glsl");
}

void draw() {
  if (menu) menu();
  else {
    updateBalls();
    showHelp();
  }
}
```
Como se puede ver, en la función *setup()*, cargamos e inicializamos todas las variables y objetos que vamos utilizar a lo largo del programa. Además, en la función *draw()*, controlamos, según los valores de variables booleanas que se manejan según la interacción del usuario con la aplicación, que pantallas se muestran por pantalla como puede ser el menú o el efecto de las *shaderBalls*.

Por otra parte, esta misma clase es la que maneja la interacción entre el usuario y la interfaz mediante la implementación del método keyPressed():
```java
void keyPressed() {
  if (keyCode == ENTER) {
    menu = false;
    cp5.show();
  }
  if (key == 'H' || key == 'h') {
    if(showColorSelector){
      cp5.hide();
      showColorSelector = !showColorSelector;
    }else{
      cp5.show();
      showColorSelector = !showColorSelector;
    }
  }
  if (key == 'B' || key == 'b'){
    blockMousePosition = !blockMousePosition;
  }
  if (key == 'C' || key == 'c'){
    for (int i = 0; i < numBalls; i++){
      balls[i].reset();
    }
  }
}
```
Además, para permitir que el usuario tenga un grado mayor de interactividad con la aplicación, se ha optado por usar la librería *controlP5* que nos da la posibilidad de incorporar un objeto a la interfaz llamado *colorWheel*. Este, muestra por pantalla un círculo que muestra los diferentes colores en formato RGB para que el usuario pueda seleccionar cuál desea en cada una de las bolas de una manera más visual. Así pues, en el método *initSystem()* inicializamos cada uno de nuestros objetos *Ball*, tantos como se hayan indicado en la variable *numBalls* en la función *setup()*, y lo vinculamos a un selector de color o *colorWheel*.
```java
void initEffect() {
  balls = new Ball[numBalls];
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball();
  }

  cp5 = new ControlP5(this);
  cp5.addColorWheel("Ball #1", 150, 650, 100).setRGB(color(random(255), random(255), random(255)));
  cp5.addColorWheel("Ball #2", 350, 650, 100).setRGB(color(random(255), random(255), random(255)));
  cp5.addColorWheel("Ball #3", 550, 650, 100).setRGB(color(random(255), random(255), random(255)));
  cp5.addColorWheel("Ball #4", 750, 650, 100).setRGB(color(random(255), random(255), random(255)));
  cp5.addColorWheel("Ball #5", 950, 650, 100).setRGB(color(random(255), random(255), random(255)));
}
```

### Clase Ball
La clase *Ball* representa a cada uno de los objetos o bolas sobre los que se aplicarán los *shaders* en la aplicación. Aquí, hemos definido unos métodos que definen el movimiento de cada bola, lo controlan e incluso resetean su posición si es indicado por el usuario.
```java
void update(){
  location.add(speed);
  checkBounds();
}
  
void checkBounds(){
  if (location.x < 0 || location.x > width){
    speed.x *= -1.0;
  }
  if (location.y < 0 || location.y > height){
    speed.y *= -1.0;
  }
}

void reset(){
  location = new PVector(random(width), random(height));
  speed = new PVector(random(-1.0, 1.0), random(-1.0, 1.0));
  speed.normalize();
  speed.mult(3);
}
```

### Clase o fichero shaderBall.glsl
En esta clase o fichero se describe e implementa la funcionalidad de los *shaders* de cada bola, en este caso, es el mismo y se repite tantas veces como bolas se muestren por pantalla (tantos como lo indique *numBalls* en la función *setup()*). Como se realizan dos efectos diferentes según el movimiento del ratón, tenemos que realizar dos operaciones diferentes:
```java
distance = size / sqrt(pow((position.x - location_Ball_One.x)*aspectRatio, 2) + pow(position.y - location_Ball_One.y, 2));
pixelColor += vec4(color_Ball_One.x, color_Ball_One.y, color_Ball_One.z, 1.0) * distance;
```

## Descarga y prueba
Para poder probar correctamente el código, descargar los ficheros (el .zip del repositorio) y en la carpeta llamada ToonShaderBalls se encuentran los archivos de la aplicación listos para probar y ejecutar. El archivo "README.md" y aquellos fuera de la carpeta del proyecto (ToonShaderBalls), son opcionales, si se descargan no deberían influir en el funcionamiento del código ya que, son usados para darle formato a la presentación y explicación del repositorio en la plataforma GitHub.

Adicionalmente, dado que se ha usado una librería adicional en esta práctica, para probarla será necesario:
- Añadir e importar la librería *controlP5* en Processing.

## Recursos empleados
Para la realización de este proyecto, se han consultado y/o utilizado los siguientes recursos:
* Guión de prácticas de la asignatura CIU
* <a href="https://processing.org">Página de oficial de Processing y sus referencias y ayudas</a>
* Processing IDE

Por otro lado, las librerías empleadas fueron:
* <a href="https://github.com/extrapixel/gif-animation">GifAnimation</a> de Patrick Meister.
* <a href="http://www.sojamo.de/libraries/controlP5/">controlP5</a> de Andreas Schlegel.
