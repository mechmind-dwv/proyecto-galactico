// ============================================
// routes/api.js - API REST Completa
// ============================================

import express from 'express';
const router = express.Router();

// ============================================
// 📊 SISTEMA DE USUARIOS
// ============================================

// Base de datos simulada (en memoria)
let users = [
  { id: 1, name: 'Capitán Galaxy', email: 'capitan@galaxy.com', role: 'admin', createdAt: new Date() },
  { id: 2, name: 'Piloto Stellar', email: 'piloto@galaxy.com', role: 'user', createdAt: new Date() }
];

let tasks = [
  { id: 1, title: 'Misión Marte', description: 'Explorar el planeta rojo', status: 'pending', userId: 1, createdAt: new Date() },
  { id: 2, title: 'Reparar Nave', description: 'Mantenimiento de motores', status: 'completed', userId: 1, createdAt: new Date() }
];

// ============================================
// 🏠 HOME / INFO
// ============================================

router.get('/', (req, res) => {
  res.json({
    name: '🚀 Proyecto Galáctico API',
    version: '1.0.0',
    status: 'online',
    endpoints: {
      users: {
        'GET    /api/users': 'Listar todos los usuarios',
        'GET    /api/users/:id': 'Obtener usuario por ID',
        'POST   /api/users': 'Crear nuevo usuario',
        'PUT    /api/users/:id': 'Actualizar usuario',
        'DELETE /api/users/:id': 'Eliminar usuario'
      },
      tasks: {
        'GET    /api/tasks': 'Listar todas las tareas',
        'GET    /api/tasks/:id': 'Obtener tarea por ID',
        'POST   /api/tasks': 'Crear nueva tarea',
        'PUT    /api/tasks/:id': 'Actualizar tarea',
        'DELETE /api/tasks/:id': 'Eliminar tarea'
      },
      stats: {
        'GET    /api/stats': 'Estadísticas generales'
      }
    },
    timestamp: new Date()
  });
});

// ============================================
// 👥 USUARIOS - CRUD COMPLETO
// ============================================

// GET - Listar todos los usuarios
router.get('/users', (req, res) => {
  const { role, limit } = req.query;
  
  let filteredUsers = users;
  
  // Filtrar por role si se proporciona
  if (role) {
    filteredUsers = filteredUsers.filter(u => u.role === role);
  }
  
  // Limitar resultados si se proporciona
  if (limit) {
    filteredUsers = filteredUsers.slice(0, parseInt(limit));
  }
  
  res.json({
    success: true,
    count: filteredUsers.length,
    data: filteredUsers
  });
});

// GET - Obtener usuario por ID
router.get('/users/:id', (req, res) => {
  const user = users.find(u => u.id === parseInt(req.params.id));
  
  if (!user) {
    return res.status(404).json({
      success: false,
      error: 'Usuario no encontrado'
    });
  }
  
  // Obtener tareas del usuario
  const userTasks = tasks.filter(t => t.userId === user.id);
  
  res.json({
    success: true,
    data: {
      ...user,
      tasks: userTasks,
      tasksCount: userTasks.length
    }
  });
});

// POST - Crear nuevo usuario
router.post('/users', (req, res) => {
  const { name, email, role } = req.body;
  
  // Validación básica
  if (!name || !email) {
    return res.status(400).json({
      success: false,
      error: 'Nombre y email son requeridos'
    });
  }
  
  // Verificar email duplicado
  if (users.find(u => u.email === email)) {
    return res.status(409).json({
      success: false,
      error: 'El email ya está registrado'
    });
  }
  
  const newUser = {
    id: users.length > 0 ? Math.max(...users.map(u => u.id)) + 1 : 1,
    name,
    email,
    role: role || 'user',
    createdAt: new Date()
  };
  
  users.push(newUser);
  
  res.status(201).json({
    success: true,
    message: 'Usuario creado exitosamente',
    data: newUser
  });
});

// PUT - Actualizar usuario
router.put('/users/:id', (req, res) => {
  const userId = parseInt(req.params.id);
  const userIndex = users.findIndex(u => u.id === userId);
  
  if (userIndex === -1) {
    return res.status(404).json({
      success: false,
      error: 'Usuario no encontrado'
    });
  }
  
  const { name, email, role } = req.body;
  
  // Actualizar solo los campos proporcionados
  if (name) users[userIndex].name = name;
  if (email) users[userIndex].email = email;
  if (role) users[userIndex].role = role;
  
  users[userIndex].updatedAt = new Date();
  
  res.json({
    success: true,
    message: 'Usuario actualizado exitosamente',
    data: users[userIndex]
  });
});

// DELETE - Eliminar usuario
router.delete('/users/:id', (req, res) => {
  const userId = parseInt(req.params.id);
  const userIndex = users.findIndex(u => u.id === userId);
  
  if (userIndex === -1) {
    return res.status(404).json({
      success: false,
      error: 'Usuario no encontrado'
    });
  }
  
  const deletedUser = users[userIndex];
  users = users.filter(u => u.id !== userId);
  
  // También eliminar sus tareas
  tasks = tasks.filter(t => t.userId !== userId);
  
  res.json({
    success: true,
    message: 'Usuario eliminado exitosamente',
    data: deletedUser
  });
});

// ============================================
// ✅ TAREAS - CRUD COMPLETO
// ============================================

// GET - Listar todas las tareas
router.get('/tasks', (req, res) => {
  const { status, userId } = req.query;
  
  let filteredTasks = tasks;
  
  // Filtrar por status
  if (status) {
    filteredTasks = filteredTasks.filter(t => t.status === status);
  }
  
  // Filtrar por userId
  if (userId) {
    filteredTasks = filteredTasks.filter(t => t.userId === parseInt(userId));
  }
  
  res.json({
    success: true,
    count: filteredTasks.length,
    data: filteredTasks
  });
});

// GET - Obtener tarea por ID
router.get('/tasks/:id', (req, res) => {
  const task = tasks.find(t => t.id === parseInt(req.params.id));
  
  if (!task) {
    return res.status(404).json({
      success: false,
      error: 'Tarea no encontrada'
    });
  }
  
  // Incluir información del usuario
  const user = users.find(u => u.id === task.userId);
  
  res.json({
    success: true,
    data: {
      ...task,
      user: user ? { id: user.id, name: user.name } : null
    }
  });
});

// POST - Crear nueva tarea
router.post('/tasks', (req, res) => {
  const { title, description, status, userId } = req.body;
  
  if (!title || !userId) {
    return res.status(400).json({
      success: false,
      error: 'Título y userId son requeridos'
    });
  }
  
  // Verificar que el usuario existe
  if (!users.find(u => u.id === parseInt(userId))) {
    return res.status(404).json({
      success: false,
      error: 'Usuario no encontrado'
    });
  }
  
  const newTask = {
    id: tasks.length > 0 ? Math.max(...tasks.map(t => t.id)) + 1 : 1,
    title,
    description: description || '',
    status: status || 'pending',
    userId: parseInt(userId),
    createdAt: new Date()
  };
  
  tasks.push(newTask);
  
  res.status(201).json({
    success: true,
    message: 'Tarea creada exitosamente',
    data: newTask
  });
});

// PUT - Actualizar tarea
router.put('/tasks/:id', (req, res) => {
  const taskId = parseInt(req.params.id);
  const taskIndex = tasks.findIndex(t => t.id === taskId);
  
  if (taskIndex === -1) {
    return res.status(404).json({
      success: false,
      error: 'Tarea no encontrada'
    });
  }
  
  const { title, description, status } = req.body;
  
  if (title) tasks[taskIndex].title = title;
  if (description) tasks[taskIndex].description = description;
  if (status) tasks[taskIndex].status = status;
  
  tasks[taskIndex].updatedAt = new Date();
  
  res.json({
    success: true,
    message: 'Tarea actualizada exitosamente',
    data: tasks[taskIndex]
  });
});

// DELETE - Eliminar tarea
router.delete('/tasks/:id', (req, res) => {
  const taskId = parseInt(req.params.id);
  const taskIndex = tasks.findIndex(t => t.id === taskId);
  
  if (taskIndex === -1) {
    return res.status(404).json({
      success: false,
      error: 'Tarea no encontrada'
    });
  }
  
  const deletedTask = tasks[taskIndex];
  tasks = tasks.filter(t => t.id !== taskId);
  
  res.json({
    success: true,
    message: 'Tarea eliminada exitosamente',
    data: deletedTask
  });
});

// ============================================
// 📊 ESTADÍSTICAS
// ============================================

router.get('/stats', (req, res) => {
  const stats = {
    users: {
      total: users.length,
      admins: users.filter(u => u.role === 'admin').length,
      regular: users.filter(u => u.role === 'user').length
    },
    tasks: {
      total: tasks.length,
      pending: tasks.filter(t => t.status === 'pending').length,
      inProgress: tasks.filter(t => t.status === 'in_progress').length,
      completed: tasks.filter(t => t.status === 'completed').length
    },
    system: {
      uptime: process.uptime(),
      memory: process.memoryUsage(),
      version: '1.0.0',
      timestamp: new Date()
    }
  };
  
  res.json({
    success: true,
    data: stats
  });
});

// ============================================
// 🔍 BÚSQUEDA
// ============================================

router.get('/search', (req, res) => {
  const { q } = req.query;
  
  if (!q) {
    return res.status(400).json({
      success: false,
      error: 'Query parameter "q" es requerido'
    });
  }
  
  const query = q.toLowerCase();
  
  const foundUsers = users.filter(u => 
    u.name.toLowerCase().includes(query) || 
    u.email.toLowerCase().includes(query)
  );
  
  const foundTasks = tasks.filter(t => 
    t.title.toLowerCase().includes(query) || 
    (t.description && t.description.toLowerCase().includes(query))
  );
  
  res.json({
    success: true,
    query: q,
    results: {
      users: foundUsers,
      tasks: foundTasks,
      totalFound: foundUsers.length + foundTasks.length
    }
  });
});

export default router;
