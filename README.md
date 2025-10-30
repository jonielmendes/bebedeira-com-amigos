# Bebedeira com Amigos

Um aplicativo Flutter divertido e interativo para animar festas e encontros com amigos! Com cartas de desafios, verdades, regras e muito mais.

## Funcionalidades

### Categorias de Jogo
- **Eu Nunca** - Quem já fez, bebe!
- **Verdade ou Desafio** - Responda honestamente ou encare o gole
- **Desafios Rápidos** - Ações simples e engraçadas
- **Picante** - Perguntas apimentadas (18+)
- **Party** - Clima de festa e risadas
- **Regras de Jogo** - Regras persistentes que mudam a dinâmica
- **Votação** - O grupo decide quem bebe

### Modos de Jogo
- **Por Categoria**: Escolha uma categoria específica
- **Modo Aleatório**: Cartas de todas as categorias misturadas

### Design Atrativo
- Gradientes vibrantes e modernos
- Animações suaves de flip nas cartas
- Efeitos visuais impactantes
- Emojis animados flutuantes
- Interface intuitiva e responsiva

### Funcionalidades Extras
- Contador de cartas viradas/restantes
- Sistema de regras ativas
- Indicadores de nível (leve, médio, pesado)
- Informações de goles por carta
- Avisos de conteúdo 18+

## Como Executar

1. Certifique-se de ter o Flutter instalado
2. Clone o repositório
3. Execute no terminal:
```bash
flutter pub get
flutter run
```

## Como Jogar

1. **Escolha o Modo**: Selecione uma categoria específica ou o modo aleatório
2. **Vire a Carta**: Toque na carta para revelar o desafio
3. **Leia em Voz Alta**: Compartilhe com o grupo
4. **Cumpra ou Beba**: Siga o desafio ou aceite a penalidade
5. **Próxima**: Avance para a próxima carta

## Estrutura do Projeto

```
lib/
├── main.dart                    # Entry point do app
├── models/
│   ├── categoria.dart          # Modelo de categoria
│   ├── carta.dart              # Modelo de carta
│   └── game_data.dart          # Modelo de dados do jogo
├── services/
│   └── game_service.dart       # Serviço para carregar dados JSON
└── screens/
    ├── home_screen.dart        # Tela inicial
    ├── categories_screen.dart  # Seleção de categorias
    └── game_screen.dart        # Tela principal do jogo

assets/
└── bebedeira.json              # Dados do jogo (cartas e categorias)
```

## Tecnologias Utilizadas

- **Flutter 3.9.2+**
- **Google Fonts** - Tipografia moderna (Poppins)
- **Animated Text Kit** - Animações de texto
- **Gradientes e Animações** - UI atrativa e fluida

## Aviso Importante

**18+ | Beba com Responsabilidade**

Este aplicativo é destinado a maiores de 18 anos. 
- Beba sempre com responsabilidade
- Conheça seus limites
- Nunca dirija após beber
- Cuide dos seus amigos

## Níveis de Desafio

- **Leve**: Perguntas e desafios tranquilos
- **Médio**: Um pouco mais ousado
- **Pesado**: Para os corajosos!

## Dicas de Uso

- Junte 3+ pessoas para mais diversão
- Tenha bebidas variadas disponíveis
- Respeite os limites de todos
- Crie novas regras personalizadas
- Use o modo aleatório para surpreender

## Licença

Projeto educacional - Use com responsabilidade e divirta-se!

---

**Desenvolvido com Flutter**

