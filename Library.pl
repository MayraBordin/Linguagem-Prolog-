% Sistema de Biblioteca Pessoal em Prolog.
% Integrantes: Luana Thurow, Mayra Bordin e Sergio Duarte.

%============ FATOS =============

:- dynamic livro/4.
:- dynamic autor/2.
:- dynamic pessoa/2.
:- dynamic emprestado/3.

% livro(Titulo, Autor, Ano, Categoria)
livro('O Senhor dos Aneis', 'J.R.R. Tolkien', 1954, 'Fantasia').
livro('1984', 'George Orwell', 1949, 'Distopia').
livro('O Pequeno Principe', 'Antoine de Saint-Exupéry', 1943, 'Infantil').
livro('Dom Quixote', 'Miguel de Cervantes', 1605, 'Clássico').
livro('A Guerra dos Tronos', 'George R.R. Martin', 1996, 'Fantasia').

% autor(Nome, Nacionalidade)
autor('J.R.R. Tolkien', 'Reino Unido').
autor('George Orwell', 'Reino Unido').
autor('Antoine de Saint-Exupéry', 'França').
autor('Miguel de Cervantes', 'Espanha').
autor('George R.R. Martin', 'Estados Unidos').

% pessoa(Nome, Identificador)
pessoa('Luana', 1).
pessoa('Mayra', 2).
pessoa('Sergio', 3).

% emprestado(Titulo, IdentificadorPessoa, DataEmprestimo)
emprestado('O Senhor dos Anéis', 1, '2024-06-01').

%============ REGRAS =============

% livros_por_autor(Autor, Titulo)
livros_por_autor(Autor, Titulo) :-
    livro(Titulo, Autor, _, _).

% livros_antigos(AnoMaximo, Titulo)
livros_antigos(AnoMaximo, Titulo) :-
    livro(Titulo, _, Ano, _),
    Ano =< AnoMaximo.

% disponivel(Titulo)
disponivel(Titulo) :-
    livro(Titulo, _, _, _),
    \+ emprestado(Titulo, _, _).

% livros_emprestados_por(NomePessoa, Titulo)
livros_emprestados_por(NomePessoa, Titulo) :-
    pessoa(NomePessoa, Identificador),
    emprestado(Titulo, Identificador, _).

%============ ATUALIZAÇÕES =============

% Inserir livro
inserir_livro(Titulo, Autor, Ano, Categoria) :-
    assertz(livro(Titulo, Autor, Ano, Categoria)).

% Emprestar livro
emprestar_livro(Titulo, IdentificadorPessoa, DataEmprestimo) :-
    livro(Titulo, _, _, _),
    pessoa(_, IdentificadorPessoa),
    \+ emprestado(Titulo, _, _),
    assertz(emprestado(Titulo, IdentificadorPessoa, DataEmprestimo)).

% Devolver livro
devolver_livro(Titulo, IdentificadorPessoa) :-
    retract(emprestado(Titulo, IdentificadorPessoa, _)).

%============ INTERFACE TEXTUAL =============

iniciar :-
    repeat,
    nl,
    write('===== BIBLIOTECA PESSOAL ====='), nl,
    write('1 - Listar livros por autor'), nl,
    write('2 - Verificar disponibilidade'), nl,
    write('3 - Inserir livro'), nl,
    write('4 - Emprestar livro'), nl,
    write('5 - Devolver livro'), nl,
    write('6 - Livros emprestados por pessoa'), nl,
    write('7 - Listar livros antigos'), nl,
    write('0 - Sair'), nl,
    write('Opcao: '), nl,
    read(Opcao),
    menu(Opcao),
    Opcao = 0.

%============ MENUS =============

menu(1) :-
    write('Autor: '), nl,
    read(Autor),

    ( autor(Autor, _)
      -> findall(Titulo,
                 livros_por_autor(Autor, Titulo),
                 Lista),
         write('Livros encontrados: '),
         write(Lista), nl
      ;  write('Autor nao cadastrado.'), nl
    ),
    !.

menu(2) :-
    write('Titulo: '), nl,
    read(Titulo),

    ( livro(Titulo, _, _, _)
      -> ( disponivel(Titulo)
           -> write('Livro disponivel.'), nl
           ;  write('Livro emprestado.'), nl
         )
      ;  write('Livro inexistente.'), nl
    ),
    !.

menu(3) :-
    write('Titulo: '), nl,
    read(Titulo),

    ( livro(Titulo, _, _, _)
      -> write('Livro ja cadastrado.'), nl
      ;  write('Autor: '), nl,
         read(Autor),

         write('Ano: '), nl,
         read(Ano),

         write('Categoria: '), nl,
         read(Categoria),

         inserir_livro(Titulo, Autor, Ano, Categoria),

         write('Livro inserido com sucesso!'), nl
    ),
    !.

menu(4) :-
    write('Titulo: '), nl,
    read(Titulo),

    write('ID da pessoa: '), nl,
    read(Id),

    write('Data (AAAA-MM-DD): '), nl,
    read(Data),

    ( emprestar_livro(Titulo, Id, Data)
      -> write('Emprestimo realizado!'), nl
      ;  write('Nao foi possivel realizar o emprestimo.'), nl
    ),
     !.

menu(5) :-
    write('Titulo: '), nl,
    read(Titulo),

    write('ID da pessoa: '), nl,
    read(Id),

    ( devolver_livro(Titulo, Id)
      -> write('Livro devolvido!'), nl
      ;  write('Emprestimo nao encontrado.'), nl
    ),
     !.

menu(6) :-
    write('Nome da pessoa: '), nl,
    read(Nome),

    ( pessoa(Nome, _)
      -> findall(Titulo,
                 livros_emprestados_por(Nome, Titulo),
                 Lista),

         ( Lista \= []
           -> write('Livros emprestados: '),
              write(Lista), nl
           ;  write('Esta pessoa nao possui livros emprestados.'), nl
         )
      ;  write('Pessoa nao cadastrada.'), nl
    ),
    !.

menu(7) :-
    write('Ano maximo: '), nl,
    read(AnoMaximo),

    findall((Titulo, Ano),
            (livro(Titulo, _, Ano, _),
             Ano =< AnoMaximo),
            Lista),

    write('Livros encontrados: '), nl,
    write(Lista), nl,
    !.

menu(0) :-
    write('Sistema encerrado.'), nl,
    halt.

menu(_) :-
    write('Opcao invalida!'), nl.