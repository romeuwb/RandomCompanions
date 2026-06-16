# RandomCompanions

**Invoque montarias e pets aleatórios com um clique.**

RandomCompanions é um addon leve para World of Warcraft (Midnight 12.0.7) que adiciona dois botões na tela — um para montarias e outro para pets — permitindo invocar companheiros aleatórios de forma rápida e prática. Pets são invocados automaticamente ao entrar no mundo, trocar de instância ou relogar.

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

- **WoW Retail:** Midnight 12.0.7+
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

# Changelog

## [1.0.3] - 2025-05-29

### Fixed

- Fixed mount type filter not working correctly with WoW 12.0 dynamic flight system
- "Flying" filter now includes all non-ground mounts (flying, aquatic, special) since all can fly in modern WoW
- "Ground" filter now correctly selects only classic ground mounts (mountType 230)
- Removed fallback that ignored filters and summoned wrong mount types

---

## [1.0.2] - 2025-05-28

### Added

- Language selection (English / Português) in settings panel
- Auto-detects WoW client language (ptBR = Portuguese, others = English)
- All messages, tooltips, and UI labels are now fully localized
- Mount type filter as a separate dropdown (combines with Favorites/All)
- New commands: /rc mg (ground), /rc mv (flying), /rc mt (all types)

### Fixed

- Fixed stack overflow caused by locale detection function name conflict
- Fixed minimap button click not working with external LibDBIcon versions
- Removed deprecated Bindings.xml (keybindings now registered via Lua only)

### Changed

- Mount selection now uses two independent filters: mode (Favorites/All) + type (All/Ground/Flying)
- Settings panel reorganized with Language section
- Minimap button OnClick now compatible with all LibDBIcon versions (MBB, HidingBar, etc.)

---

## [1.0.1] - 2025-05-28

### Fixed

- Mount button no longer summons the currently active mount
- Pet button now swaps in 1 click (no longer dismisses before summoning)
- Removed circular border from buttons, now uses clean square style

### Changed

- Mount button only summons, no longer dismounts (WoW swaps automatically)
- Buttons now use action bar style border (square, subtle)
- Right-click on mount button toggles Favorites/All (type is set in settings panel)

---

## [1.0.0] - 2025-05-26

### Added

- On-screen mount button — summons a random mount with one click
- On-screen pet button — summons a random pet with one click (auto-swap)
- Auto-pet: automatically summons a pet on login, reload, or instance change
- Selection modes: Favorites/All for mounts, Favorites/All for pets
- Draggable buttons with position saved between sessions
- Adjustable button scale (50% to 200%)
- Option to lock button position
- Minimap icon for quick access to settings
- Settings panel integrated into WoW's Interface menu
- Configurable keybindings (Key Bindings > RandomCompanions)
- Chat commands (/rc)
- Auto-hide during Pet Battles, cinematics, and minigames
- Compatible with WoW 12.0.5 (Midnight)

---
---

# Changelog (Português)

## [1.0.3] - 2025-05-29

### Corrigido

- Corrigido filtro de tipo de montaria não funcionando com sistema de voo dinâmico do WoW 12.0
- Filtro "Voadoras" agora inclui todas as montarias não-terrestres (voadoras, aquáticas, especiais) já que todas podem voar no WoW moderno
- Filtro "Terrestres" agora seleciona corretamente apenas montarias terrestres clássicas (mountType 230)
- Removido fallback que ignorava filtros e invocava montarias erradas

---

## [1.0.2] - 2025-05-28

### Adicionado

- Seleção de idioma (English / Português) no painel de opções
- Detecção automática do idioma do cliente WoW
- Todas as mensagens, tooltips e labels agora são localizados
- Filtro de tipo de montaria como dropdown separado (combina com Favoritas/Todas)
- Novos comandos: /rc mg (terrestres), /rc mv (voadoras), /rc mt (todas)

### Corrigido

- Corrigido stack overflow causado por conflito de nome na função de detecção de idioma
- Corrigido clique no botão do minimapa não funcionando com versões externas do LibDBIcon
- Removido Bindings.xml obsoleto (keybindings agora registrados via Lua)

### Alterado

- Seleção de montarias agora usa dois filtros independentes: modo (Favoritas/Todas) + tipo (Todas/Terrestres/Voadoras)
- Painel de opções reorganizado com seção de Idioma
- OnClick do minimapa agora compatível com todas as versões do LibDBIcon (MBB, HidingBar, etc.)

---

## [1.0.1] - 2025-05-28

### Corrigido

- Botão de montaria não repete mais a montaria que já está ativa
- Botão de pet agora troca em 1 clique (não dispensa mais antes de invocar)
- Removido círculo/borda redonda dos botões, agora usam visual quadrado limpo

### Alterado

- Botão de montaria apenas invoca, não desmonta mais (WoW troca automaticamente)
- Botões agora usam borda estilo action bar (quadrada, sutil)
- Clique direito no botão de montaria alterna entre Favoritas/Todas (tipo é configurado no painel)

---

## [1.0.0] - 2025-05-26

### Adicionado

- Botão de montaria na tela — invoca montaria aleatória com um clique
- Botão de pet na tela — invoca pet aleatório com um clique (troca automática)
- Auto-pet: invoca pet automaticamente ao entrar no mundo, relogar ou trocar de instância
- Modos de seleção: Favoritas/Todas para montarias, Favoritos/Todos para pets
- Botões movíveis com posição salva entre sessões
- Escala ajustável dos botões (50% a 200%)
- Opção de travar posição dos botões
- Ícone no minimapa para acesso rápido às configurações
- Painel de configurações integrado ao menu Interface do WoW
- Keybindings configuráveis (Atalhos > RandomCompanions)
- Comandos de chat (/rc)
- Ocultação automática durante Pet Battles, cinematics e minigames
- Compatível com WoW 12.0.5 (Midnight)
