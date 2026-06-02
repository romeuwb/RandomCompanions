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
