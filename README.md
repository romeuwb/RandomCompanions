# RandomCompanions

**Invoque montarias e pets aleatórios com um clique.**

RandomCompanions é um addon leve para World of Warcraft (Midnight 12.0.5) que adiciona dois botões na tela — um para montarias e outro para pets — permitindo invocar companheiros aleatórios de forma rápida e prática. Pets são invocados automaticamente ao entrar no mundo, trocar de instância ou relogar.

---

## Funcionalidades

### Botões na Tela
- **Botão de Montaria** — Invoca uma montaria aleatória a cada clique
- **Botão de Pet** — Invoca um pet aleatório a cada clique (troca automaticamente se já houver um ativo)
- Botões movíveis para qualquer posição da tela
- Posição salva entre sessões
- Escala ajustável (50% a 200%)
- Opção de travar posição
- Ocultam automaticamente durante Pet Battles, cinematics e minigames

### Modos de Seleção
- **Favoritas/Favoritos** — Invoca apenas entre montarias/pets marcados como favoritos
- **Todas/Todos** — Invoca entre toda a coleção disponível
- Alternável via clique direito nos botões ou no painel de opções

### Auto-Pet
- Invoca um pet aleatório automaticamente ao:
  - Entrar no mundo (login)
  - Relogar (/reload)
  - Trocar de instância
  - Entrar em qualquer zona nova
- Pode ser ativado/desativado nas configurações

### Ícone no Minimapa
- Um ícone discreto no minimapa para acesso rápido às configurações
- Clique esquerdo: abre o painel de opções
- Clique direito: mostra/oculta os botões da tela
- Arrastável ao redor do minimapa

### Painel de Configurações
Acessível via Interface > Addons > RandomCompanions ou `/rc config`:
- Modo de seleção de montarias (Favoritas / Todas)
- Modo de seleção de pets (Favoritos / Todos)
- Auto-pet on/off
- Mostrar/ocultar botões
- Travar posição dos botões
- Ajustar tamanho dos botões
- Resetar posição
- Mostrar/ocultar ícone do minimapa

### Keybindings
Configuráveis em Opções > Atalhos > RandomCompanions:
- Invocar Montaria Aleatória
- Invocar Pet Aleatório

---

## Comandos de Chat

| Comando | Ação |
|---------|------|
| `/rc mount` | Invocar montaria aleatória |
| `/rc pet` | Invocar pet aleatório |
| `/rc mf` | Montarias: modo favoritas |
| `/rc ma` | Montarias: modo todas |
| `/rc pf` | Pets: modo favoritos |
| `/rc pa` | Pets: modo todos |
| `/rc autopet on/off` | Ativar/desativar auto-pet |
| `/rc toggle` | Mostrar/ocultar botões |
| `/rc lock` | Travar/destravar posição |
| `/rc config` | Abrir configurações |
| `/rc reset` | Resetar posição dos botões |

---

## Instalação

1. Baixe o addon
2. Extraia a pasta `RandomCompanions` em:
   ```
   World of Warcraft\_retail_\Interface\AddOns\
   ```
3. Reinicie o WoW ou digite `/reload`

---

## Compatibilidade

- **WoW Retail:** Midnight 12.0.5+
- **Interface:** 120005
- **Dependências:** Nenhuma (libs embutidas)

---

## FAQ

**Os botões somem durante Pet Battles?**
Sim, eles se ocultam automaticamente durante Pet Battles, cinematics e minigames, e voltam quando a situação termina.

**Preciso ter montarias/pets favoritos?**
Não. Se não houver favoritos marcados, o addon usa toda a coleção disponível como fallback.

**O addon funciona em Classic/Era?**
Não. Foi desenvolvido para WoW Retail (Midnight).

**Como mover os botões?**
Arraste-os com o mouse. Para travar a posição, use `/rc lock` ou marque a opção no painel de configurações.

---

## Changelog

### v1.0.0
- Lançamento inicial
- Dois botões na tela (montaria + pet)
- Auto-pet ao entrar no mundo/instância
- Painel de configurações integrado
- Ícone no minimapa
- Keybindings configuráveis
- Ocultação automática em Pet Battles/cinematics
