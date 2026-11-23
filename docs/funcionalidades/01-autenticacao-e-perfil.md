# 01 - Autenticação, Sessão e Perfil de Usuário

## 1. Visão Geral
O módulo de autenticação gerencia o acesso seguro ao SIGOE por meio de credenciais institucionais e tokens JWT (*JSON Web Tokens*), com controle de expiração e lista de revogação (*denylist*).

---

## 2. Fluxo de Login
1. Acesse a URL do SIGOE no navegador. Caso você não esteja autenticado, será automaticamente redirecionado para a rota `/`.
2. Informe:
   * **Usuário / E-mail**: Seu identificador institucional cadastrado.
   * **Senha**: Sua senha de acesso.
3. Clique em **Entrar**.
4. O sistema valida as credenciais com a API backend:
   * Se os dados estiverem corretos e a conta estiver ativa (`status: true`), o token JWT é gerado e armazenado localmente na sessão.
   * Se as credenciais forem inválidas ou a conta estiver inativa, uma notificação de alerta é exibida.

---

## 3. Troca de Senha
Qualquer usuário autenticado pode alterar sua própria senha:
1. No menu superior direito (Header), clique sobre seu nome/avatar.
2. Selecione a opção **Trocar Senha** (rota `/administrador/usuarios/trocar-senha`).
3. Preencha os campos obrigatórios:
   * **Senha Atual**: Necessária para confirmar a identidade do usuário.
   * **Nova Senha**: Mínimo de 6 caracteres.
   * **Confirmação da Nova Senha**: Deve ser idêntica à nova senha digitada.
4. Clique em **Salvar**. A nova senha passa a valer imediatamente.

---

## 4. Encerramento de Sessão (Logout)
* Clique no menu do perfil no canto superior direito e selecione **Sair**.
* A sessão do usuário é encerrada, o token JWT é revogado no backend e o navegador é redirecionado para a tela inicial de login.
