import { createRouter, createWebHistory } from "vue-router"
import { isTokenValid } from "@/services/authentication"
import { can, loadCurrentPermissions, permissionState } from "@/services/permissions"
import Home from "@/views/home.vue"; import Login from "@/views/login.vue"; import Forbidden from "@/views/forbidden.vue"; import UserList from "@/views/users/list.vue"; import UserView from "@/views/users/show.vue"; import UserForm from "@/views/users/form.vue"; import UserPermissions from "@/views/users/permissions.vue"; import StudentList from "@/views/students/list.vue"; import StudentView from "@/views/students/show.vue"; import StudentForm from "@/views/students/form.vue"; import CourseList from "@/views/courses/list.vue"; import CourseForm from "@/views/courses/form.vue"; import SchoolGroupsList from "@/views/school_groups/list.vue"; import SchoolGroupForm from "@/views/school_groups/form.vue"; import IncidentsList from "@/views/incidents/list.vue"; import IncidentsForm from "@/views/incidents/form.vue"; import IncidentsView from "@/views/incidents/show.vue"; import IncidentsReport from "@/views/incidents/report.vue"; import ChangePassword from "@/views/users/change-password.vue"
import MobileDashboard from "@/views/mobile/Dashboard.vue"
import MobileIncidentList from "@/views/mobile/incidents/Index.vue"
import MobileIncidentForm from "@/views/mobile/incidents/Form.vue"
import MobileIncidentShow from "@/views/mobile/incidents/Show.vue"
import MobileCourseList from "@/views/mobile/courses/Index.vue"
import MobileCourseForm from "@/views/mobile/courses/Form.vue"
import MobileSchoolGroupList from "@/views/mobile/school-groups/Index.vue"
import MobileSchoolGroupForm from "@/views/mobile/school-groups/Form.vue"
import MobileStudentList from "@/views/mobile/students/Index.vue"
import MobileStudentForm from "@/views/mobile/students/Form.vue"
import MobileStudentShow from "@/views/mobile/students/Show.vue"
import MobileUserList from "@/views/mobile/users/Index.vue"
import MobileUserForm from "@/views/mobile/users/Form.vue"
import MobileUserShow from "@/views/mobile/users/Show.vue"
import MobileUserPermissions from "@/views/mobile/users/Permissions.vue"
const routes = [
{path:"/mobile/dashboard",component:MobileDashboard,meta:{auth:true,mobile:true,mobileTitle:"Dashboard"}},
{path:"/mobile/incidents",component:MobileIncidentList,meta:{auth:true,mobile:true,mobileTitle:"Ocorrências",permission:{entity:"occurrences",action:"read"}}},
{path:"/mobile/incidents/new",component:MobileIncidentForm,meta:{auth:true,mobile:true,mobileTitle:"Nova ocorrência",permission:{entity:"occurrences",action:"create"}}},
{path:"/mobile/incidents/:id",component:MobileIncidentShow,meta:{auth:true,mobile:true,mobileTitle:"Detalhes da ocorrência",permission:{entity:"occurrences",action:"read"}}},
{path:"/mobile/incidents/:id/edit",component:MobileIncidentForm,meta:{auth:true,mobile:true,mobileTitle:"Editar ocorrência",permission:{entity:"occurrences",action:"update"}}},
{path:"/mobile/courses",component:MobileCourseList,meta:{auth:true,mobile:true,mobileTitle:"Cursos",permission:{entity:"courses",action:"read"}}},
{path:"/mobile/courses/new",component:MobileCourseForm,meta:{auth:true,mobile:true,mobileTitle:"Novo curso",permission:{entity:"courses",action:"create"}}},
{path:"/mobile/courses/:id/edit",component:MobileCourseForm,meta:{auth:true,mobile:true,mobileTitle:"Editar curso",permission:{entity:"courses",action:"update"}}},
{path:"/mobile/school-groups",component:MobileSchoolGroupList,meta:{auth:true,mobile:true,mobileTitle:"Turmas",permission:{entity:"classes",action:"read"}}},
{path:"/mobile/school-groups/new",component:MobileSchoolGroupForm,meta:{auth:true,mobile:true,mobileTitle:"Nova turma",permission:{entity:"classes",action:"create"}}},
{path:"/mobile/school-groups/:id/edit",component:MobileSchoolGroupForm,meta:{auth:true,mobile:true,mobileTitle:"Editar turma",permission:{entity:"classes",action:"update"}}},
{path:"/mobile/students",component:MobileStudentList,meta:{auth:true,mobile:true,mobileTitle:"Estudantes",permission:{entity:"students",action:"read"}}},
{path:"/mobile/students/new",component:MobileStudentForm,meta:{auth:true,mobile:true,mobileTitle:"Novo estudante",permission:{entity:"students",action:"create"}}},
{path:"/mobile/students/:id",component:MobileStudentShow,meta:{auth:true,mobile:true,mobileTitle:"Detalhes do estudante",permission:{entity:"students",action:"read"}}},
{path:"/mobile/students/:id/edit",component:MobileStudentForm,meta:{auth:true,mobile:true,mobileTitle:"Editar estudante",permission:{entity:"students",action:"update"}}},
{path:"/mobile/users",component:MobileUserList,meta:{auth:true,mobile:true,mobileTitle:"Usuários",permission:{entity:"users",action:"read"}}},
{path:"/mobile/users/new",component:MobileUserForm,meta:{auth:true,mobile:true,mobileTitle:"Novo usuário",permission:{entity:"users",action:"create"}}},
{path:"/mobile/users/:id",component:MobileUserShow,meta:{auth:true,mobile:true,mobileTitle:"Detalhes do usuário",permission:{entity:"users",action:"read"}}},
{path:"/mobile/users/:id/edit",component:MobileUserForm,meta:{auth:true,mobile:true,mobileTitle:"Editar usuário",permission:{entity:"users",action:"update"}}},
{path:"/mobile/users/:id/permissions",component:MobileUserPermissions,meta:{auth:true,mobile:true,mobileTitle:"Permissões",permission:{entity:"users",action:"update",adminOnly:true}}},
{path:"/",component:Login,meta:{auth:false}},{path:"/home",component:Home,meta:{auth:true}},{path:"/sem-permissao",component:Forbidden,meta:{auth:true}},
{path:"/administrador/usuarios/listar",component:UserList,meta:{auth:true,permission:{entity:"users",action:"read"}}},{path:"/administrador/usuarios/visualizar/:id",component:UserView,meta:{auth:true,permission:{entity:"users",action:"read"}}},{path:"/administrador/usuarios/novo",component:UserForm,meta:{auth:true,permission:{entity:"users",action:"create"}}},{path:"/administrador/usuarios/editar/:id",component:UserForm,meta:{auth:true,permission:{entity:"users",action:"update"}}},{path:"/administrador/usuarios/visualizar/:id/permissoes",component:UserPermissions,meta:{auth:true,permission:{entity:"users",action:"update",adminOnly:true}}},{path:"/administrador/usuarios/trocar-senha",component:ChangePassword,meta:{auth:true}},
{path:"/administrador/estudantes/listar",component:StudentList,meta:{auth:true,permission:{entity:"students",action:"read"}}},{path:"/administrador/estudantes/novo",component:StudentForm,meta:{auth:true,permission:{entity:"students",action:"create"}}},{path:"/administrador/estudantes/visualizar/:id",component:StudentView,meta:{auth:true,permission:{entity:"students",action:"read"}}},{path:"/administrador/estudantes/editar/:id",component:StudentForm,meta:{auth:true,permission:{entity:"students",action:"update"}}},
{path:"/administrador/cursos/listar",component:CourseList,meta:{auth:true,permission:{entity:"courses",action:"read"}}},{path:"/administrador/cursos/novo",component:CourseForm,meta:{auth:true,permission:{entity:"courses",action:"create"}}},{path:"/administrador/cursos/editar/:id",component:CourseForm,meta:{auth:true,permission:{entity:"courses",action:"update"}}},
{path:"/administrador/turmas/listar",component:SchoolGroupsList,meta:{auth:true,permission:{entity:"classes",action:"read"}}},{path:"/administrador/turmas/novo",component:SchoolGroupForm,meta:{auth:true,permission:{entity:"classes",action:"create"}}},{path:"/administrador/turmas/editar/:id",component:SchoolGroupForm,meta:{auth:true,permission:{entity:"classes",action:"update"}}},
{path:"/ocorrencias/ocorrencias/listar",component:IncidentsList,meta:{auth:true,permission:{entity:"occurrences",action:"read"}}},{path:"/ocorrencias/ocorrencias/novo",component:IncidentsForm,meta:{auth:true,permission:{entity:"occurrences",action:"create"}}},{path:"/ocorrencias/ocorrencias/visualizar/:id",component:IncidentsView,meta:{auth:true,permission:{entity:"occurrences",action:"read"}}},{path:"/ocorrencias/ocorrencias/editar/:id",component:IncidentsForm,meta:{auth:true,permission:{entity:"occurrences",action:"update"}}},{path:"/ocorrencias/relatorio",component:IncidentsReport,meta:{auth:true,permission:{entity:"occurrences",action:"read"}}}]
const router=createRouter({history:createWebHistory(),routes})
router.beforeEach(async(to,_from,next)=>{if(!to.meta.auth){next();return}if(!(await isTokenValid())){next({path:"/"});return}await loadCurrentPermissions();const p=to.meta.permission;if(p&&(p.adminOnly&&!permissionState.admin||!can(p.entity,p.action))){next({path:"/sem-permissao"});return}next()})
export default router
