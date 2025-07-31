# 🕳️ Puit de LOG - GLF  
**Grafana • Loki • Fluent Bit**

> Stack de collecte, centralisation et visualisation de logs.

---

## ⚙️ Installation

### 1. Cloner le dépôt

```bash
git clone https://github.com/votre-utilisateur/puit-de-log-glf.git
cd puit-de-log-glf
```
### 2. Lancer le script d’installation

```bash
chmod +x setup.sh
./setup.sh
```

Ce script :

- Crée le réseau Docker lokinet si besoin

- Applique les permissions nécessaires (UID/GID)

- Lance tous les conteneurs avec docker-compose

---

### 🔐 Reverse Proxy (facultatif)

Le dossier reverseproxy/conf.d/nginx.conf contient un exemple de configuration Nginx avec redirection HTTPS.
Il faut l'adapter au contexte.

 ---

### 🌍 Accès aux interfaces

Grafana : http://localhost:3000
(ou via le reverse proxy si configuré)

---

### 🧾 Notes

Aucun volume Docker n’est utilisé : "bind mounts uniquement"

loki et grafana écrivent dans DATA/
