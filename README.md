# 🚌 Unimar Transport App  

Aplicativo desenvolvido em **Flutter** para a Unimar, focado em transporte universitário.  
Permite que estudantes, validadores e administradores organizem tickets, validem QR Codes e gerenciem eventos de forma rápida e intuitiva.  

---

## ✨ Funcionalidades  

- 🔐 **Autenticação Segura**: Login e registro de usuários com Firebase Auth  
- 👤 **Perfil do Usuário**: Personalização de informações e preferências  
- 🎟️ **Tickets Digitais**: Geração de tickets com QR Code  
- ✅ **Validação em Tempo Real**: Scanner integrado para motoristas/validadores  
- 🕒 **Horários de Ônibus**: Consulta rápida e atualizada  
- 🗺️ **Mapa Interativo**: Navegação pelo campus  
- 📅 **Eventos Acadêmicos**: Visualização e participação em eventos  
- 🎨 **Tutorial Inicial**: Onboarding para novos usuários  
- 🍔 **Menu Flutuante Customizado**: Acesso rápido e animado às telas principais  

---

## 🛠️ Tecnologias Utilizadas  

- 📱 **Frontend**: Flutter 3.x + Dart  
- 🔐 **Autenticação**: Firebase Auth  
- 🗄️ **Banco de Dados**: Firebase Firestore  
- 💾 **Armazenamento Local**: SharedPreferences  
- 📷 **QR Code**: `qr_flutter` + `mobile_scanner`  
- 🎨 **UI/UX**: Material Design + animações personalizadas  

---

## 🚀 Como Executar  

### Pré-requisitos  
- Flutter SDK 3.x  
- Android Studio ou VS Code  
- Emulador Android ou dispositivo físico  

### Instalação  

```bash
# Clone o repositório
git clone [url-do-repositorio]

# Acesse o diretório
cd unimar-transport-app

# Instale as dependências
flutter pub get

# Execute no emulador ou dispositivo
flutter run
