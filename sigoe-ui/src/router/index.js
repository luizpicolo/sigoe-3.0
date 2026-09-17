import { createRouter, createWebHistory } from "vue-router"
import { isTokenValid } from "@/services/authentication"
import { can, loadCurrentPermissions } from "@/services/permissions"

import Home from "@/views/home.vue"
import Login from "@/views/login.vue"
import Forbidden from "@/views/forbidden.vue"
import UserList from "@/views/users/list.vue"
import UserView from "@/views/users/show.vue"
import UserNew from "@/views/users/new.vue"
import UserPermissions from "@/views/users/permissions.vue"
import StudentList from "@/views/students/list.vue"
import StudentView from "@/views/students/show.vue"
import StudentNew from "@/views/students/new.vue"
import StudentEdit from "@/views/students/edit.vue"
import CourseList from "@/views/courses/list.vue"
import SchoolGroupsList from "@/views/school_groups/list.vue"
import IncidentsList from "@/views/incidents/list.vue"
import IncidentsNew from "@/views/incidents/new.vue"
import IncidentsView from "@/views/incidents/show.vue"
import IncidentsEdit from "@/views/incidents/edit.vue"
import IncidentsReport from "@/views/incidents/report.vue"
import ChangePassword from "@/views/users/change-password.vue"

const routes = [
  { path: "/", component: Login, meta: { auth: false } },
  { path: "/home", component: Home, meta: { auth: true } },
  { path: "/sem-permissao", component: Forbidden, meta: { auth: true } },

  // Usuários
  { path: "/administrador/usuarios/listar", component: UserList, meta: { auth: true, permission: { entity: "users", action: "read" } } },
  { path: "/administrador/usuarios/visualizar/:id", component: UserView, meta: { auth: true, permission: { entity: "users", action: "read" } } },
  { path: "/administrador/usuarios/novo", component: UserNew, meta: { auth: true, permission: { entity: "users", action: "create" } } },
  { path: "/administrador/usuarios/permissoes/:id/", component: UserPermissions, meta: { auth: true, permission: { entity: "users", action: "update" } } },
  { path: "/administrador/usuarios/trocar-senha", component: ChangePassword, meta: { auth: true } },

  // Estudantes
  { path: "/administrador/estudantes/listar", component: StudentList, meta: { auth: true, permission: { entity: "students", action: "read" } } },
  { path: "/administrador/estudantes/novo", component: StudentNew, meta: { auth: true, permission: { entity: "students", action: "create" } } },
  { path: "/administrador/estudantes/visualizar/:id", component: StudentView, meta: { auth: true, permission: { entity: "students", action: "read" } } },
  { path: "/administrador/estudantes/editar/:id", component: StudentEdit, meta: { auth: true, permission: { entity: "students", action: "update" } } },

  // Cursos e Turmas
  { path: "/administrador/cursos/listar", component: CourseList, meta: { auth: true, permission: { entity: "courses", action: "read" } } },
  { path: "/administrador/turmas/listar", component: SchoolGroupsList, meta: { auth: true, permission: { entity: "classes", action: "read" } } },

  // Ocorrências
  { path: "/ocorrencias/ocorrencias/listar", component: IncidentsList, meta: { auth: true, permission: { entity: "occurrences", action: "read" } } },
  { path: "/ocorrencias/ocorrencias/novo", component: IncidentsNew, meta: { auth: true, permission: { entity: "occurrences", action: "create" } } },
  { path: "/ocorrencias/ocorrencias/visualizar/:id", component: IncidentsView, meta: { auth: true, permission: { entity: "occurrences", action: "read" } } },
  { path: "/ocorrencias/ocorrencias/editar/:id", component: IncidentsEdit, meta: { auth: true, permission: { entity: "occurrences", action: "update" } } },
  { path: "/ocorrencias/relatorio", component: IncidentsReport, meta: { auth: true, permission: { entity: "occurrences", action: "read" } } },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach(async (to, _from, next) => {
  if (!to.meta.auth) {
    next()
    return
  }

  if (!(await isTokenValid())) {
    next({ path: "/" })
    return
  }

  await loadCurrentPermissions()

  const permission = to.meta.permission
  if (permission && !can(permission.entity, permission.action)) {
    next({ path: "/sem-permissao" })
    return
  }

  next()
})

export default router
