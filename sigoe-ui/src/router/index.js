import { createRouter, createWebHistory } from "vue-router"
import { isTokenValid } from "@/services/authentication"

import Home from "@/views/home.vue"
import Login from "@/views/login.vue"
import UserList from "@/views/users/list.vue"
import UserView from "@/views/users/show.vue"
import UserNew from "@/views/users/new.vue"
import UserPermissions from "@/views/users/permissions.vue"
import StudentList from "@/views/students/list.vue"
import StudentView from "@/views/students/show.vue"
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

  // Usuários
  { path: "/administrador/usuarios/listar", component: UserList, meta: { auth: true } },
  { path: "/administrador/usuarios/visualizar/:id", component: UserView, meta: { auth: true } },
  { path: "/administrador/usuarios/novo", component: UserNew, meta: { auth: true } },
  { path: "/administrador/usuarios/permissoes/:id/", component: UserPermissions, meta: { auth: true } },
  { path: "/administrador/usuarios/trocar-senha", component: ChangePassword, meta: { auth: true } },

  // Estudantes
  { path: "/administrador/estudantes/listar", component: StudentList, meta: { auth: true } },
  { path: "/administrador/estudantes/visualizar/:id", component: StudentView, meta: { auth: true } },
  { path: "/administrador/estudantes/editar/:id", component: StudentEdit, meta: { auth: true } },

  // Cursos e Turmas
  { path: "/administrador/cursos/listar", component: CourseList, meta: { auth: true } },
  { path: "/administrador/turmas/listar", component: SchoolGroupsList, meta: { auth: true } },

  // Ocorrências
  { path: "/ocorrencias/ocorrencias/listar", component: IncidentsList, meta: { auth: true } },
  { path: "/ocorrencias/ocorrencias/novo", component: IncidentsNew, meta: { auth: true } },
  { path: "/ocorrencias/ocorrencias/visualizar/:id", component: IncidentsView, meta: { auth: true } },
  { path: "/ocorrencias/ocorrencias/editar/:id", component: IncidentsEdit, meta: { auth: true } },
  { path: "/ocorrencias/relatorio", component: IncidentsReport, meta: { auth: true } },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach(async (to, _from, next) => {
  if (to.meta.auth) {
    if (await isTokenValid()) {
      next()
    } else {
      next({ path: "/" })
    }
  } else {
    next()
  }
})

export default router
