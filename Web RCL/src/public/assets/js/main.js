function loadModule(nombre) {
  fetch(`modules/${nombre}.html`)
    .then(respuesta => respuesta.text())
    .then(contenido => {
      document.getElementById("content").innerHTML = contenido;
    });
}

// Cargar la barra de navegación
fetch("modules/navbar.html")
  .then(respuesta => respuesta.text())
  .then(contenido => {
    document.getElementById("navbar").innerHTML = contenido;
  });

// Página inicial
loadModule("fase-regular");
