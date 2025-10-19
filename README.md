# App Gestão de Pessoas (Flutter + MockAPI)

Este é um projeto de aplicativo móvel desenvolvido em Flutter que implementa um CRUD (Criar, Ler, Atualizar, Deletar) completo de "Pessoas" e um sistema simulado de Login e Registro.

O objetivo deste projeto é demonstrar a construção de um aplicativo Flutter robusto, com gerenciamento de estado (`provider`), navegação e consumo de uma API RESTful. O back-end é simulado usando o serviço gratuito **MockAPI.io** para prototipagem rápida.

## Funcionalidades

* **Autenticação Simulada:**
    * Tela de Registro (Cria um `usuario` na API).
    * Tela de Login (Verifica se o `usuario` e `senha` existem na API).
    * Persistência de sessão (usuário continua logado ao fechar e reabrir o app).
* **Gestão de Pessoas (CRUD):**
    * **Listar** todas as pessoas cadastradas (`HomeScreen`).
    * **Criar** uma nova pessoa (Formulário).
    * **Editar** uma pessoa existente (Formulário).
    * **Excluir** uma pessoa (com diálogo de confirmação).

## Tecnologias Utilizadas

* **Front-end:**
    * **Flutter** (SDK)
    * **Dart** (Linguagem)
    * **provider:** Para gerenciamento de estado.
    * **http:** Para realizar as chamadas à API REST.
    * **shared_preferences:** Para persistir o estado de login.
* **Back-end (Simulado):**
    * **MockAPI.io:** Para gerar endpoints RESTful gratuitos.

---

## Como Rodar o Projeto

Para executar este projeto, você precisa configurar duas partes: o **Back-end** (MockAPI) e o **Front-end** (Flutter).

### 1. Configuração do Back-end (MockAPI.io)

Você precisa criar os endpoints da API que o aplicativo irá consumir.

1.  **Crie uma conta:** Acesse [https://mockapi.io/](https://mockapi.io/) e crie uma conta gratuita.
2.  **Crie um novo Projeto:** Dê um nome a ele (ex: `AppPessoas`).
3.  **Anote sua URL Base:** O MockAPI lhe dará uma URL única. Ela será algo como: `https://[SEU_HASH_UNICO].mockapi.io/api/v1`
    *(Nota: Você pode customizar o prefixo `api/v1` se desejar. O exemplo do projeto usou `a1mobile`)*.
4.  **Crie o Recurso `usuario`:**
    * Clique em "New Resource".
    * Nome do Recurso: `usuario` (no singular).
    * Defina o **Schema** com os seguintes campos (exatamente com estes nomes):
        * `usuario` (tipo: String)
        * `email` (tipo: String)
        * `senha` (tipo: String)
5.  **Crie o Recurso `pessoa`:**
    * Clique em "New Resource" novamente.
    * Nome do Recurso: `pessoa` (no singular).
    * Defina o **Schema** com os seguintes campos:
        * `nome` (tipo: String)
        * `cpf` (tipo: String)
        * `telefone` (tipo: String)
6.  **(Opcional) Crie Dados de Teste:** No recurso `usuario`, vá até a aba "Data" e crie manualmente um ou dois usuários (ex: `usuario: "teste"`, `senha: "123"`) para que você possa testar o login.

### 2. Configuração do Front-end (Flutter)

Agora, vamos configurar o código do app para apontar para a sua API.

1.  **Clone o Repositório** (ou tenha os arquivos do projeto em seu computador).
    ```bash
    # Se estivesse no Git
    git clone https://[URL_DO_SEU_REPOSITORIO].git
    cd nome-do-projeto
    ```
2.  **Atualize a URL da API:**
    * Abra o arquivo: `lib/services/api_service.dart`.
    * Encontre a linha que define o `_baseUrl`.
    * **Substitua** a URL de exemplo pela URL base completa do **seu** projeto no MockAPI (a que você anotou no Passo 1.3).

    ```dart
    // lib/services/api_service.dart

    class ApiService {
      // SUBSTITUA PELA SUA URL DO MOCKAPI
      static const String _baseUrl = 'https://[SEU_HASH_UNICO].mockapi.io/[SEU_PREFIXO]'; 
      // Ex: '[https://68f43cd7b16eb6f468341e30.mockapi.io/a1mobile](https://68f43cd7b16eb6f468341e30.mockapi.io/a1mobile)'

      // ... resto do código
    }
    ```

3.  **Instale as Dependências:**
    Abra um terminal na pasta raiz do projeto e execute:
    ```bash
    flutter pub get
    ```
4.  **Habilite Permissão de Internet (Android):**
    * Verifique se o arquivo `android/app/src/main/AndroidManifest.xml` contém a permissão de internet.
    * Adicione esta linha se ela não existir (geralmente acima da tag `<application>`):
    ```xml
    <uses-permission android:name="android.permission.INTERNET" />
    ```

### 3. Executando o Aplicativo

Com o back-end pronto e o front-end configurado:

1.  Abra um emulador Android ou conecte um dispositivo físico.
2.  Execute o comando no terminal:
    ```bash
    flutter run
    ```
3.  O aplicativo irá iniciar. Você pode:
    * **Registrar** um novo usuário.
    * **Fazer login** com o usuário que você registrou (ou criou manualmente no MockAPI).
    * Ser redirecionado para a tela de Pessoas, onde poderá testar o CRUD.

---

## Estrutura do Projeto

A estrutura de pastas foi organizada para separar responsabilidades:

* `lib/`
    * `main.dart`: Ponto de entrada. Controla a navegação inicial (Login vs. Home) usando um `Consumer` do `AuthProvider`.
    * `models/`: Contém as classes de modelo que mapeiam o JSON da API (ex: `pessoa.dart`).
    * `providers/`: Gerenciadores de estado que orquestram a lógica de negócio.
        * `auth_provider.dart`: Gerencia o estado de login/logout.
        * `pessoa_provider.dart`: Gerencia a lista de pessoas e as operações de CRUD.
    * `screens/`: As telas (Widgets) que o usuário vê.
        * `login_screen.dart`
        * `register_screen.dart`
        * `home_screen.dart` (Tela de Pessoas - Listagem)
        * `pessoa_form_screen.dart` (Formulário de Criar/Editar)
    * `services/`: Classes responsáveis pela comunicação com o mundo externo.
        * `api_service.dart`: Centraliza todas as chamadas HTTP (login, getPessoas, createPessoa, etc.).