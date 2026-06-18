# Migración PHP → Node.js MVC

## Instalar
```bash
npm install
copy .env.example .env
```

## Ejecutar
```bash
npm start
```

## Rutas principales
- `/`
- `/calendario`
- `/clasificacion`
- `/equipos`
- `/equipos/:id`
- `/jugadores`
- `/fails`
- `/playoffs`
- `/admin/login`

## Notas
- Este proyecto usa `EJS` como motor de vistas.
- Los datos sensibles se leen desde `.env`.
- El panel admin usa `express-session`.
