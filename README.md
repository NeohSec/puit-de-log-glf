# 🕳️ Puit de LOG - GLF  
**Grafana • Loki • Fluent Bit**

> Stack de collecte, centralisation et visualisation de logs — simple, brutale, efficace.

---

## 📁 Structure du projet
puit-de-log-glf/
├── DATA
│   ├── fluent-bit.conf
│   ├── grafana
│   └── loki
├── docker-compose.yml
├── reverseproxy
│   ├── certs
│   └── conf.d
│       └── nginx.conf
└── setup.sh

7 directories, 4 files

---

## ⚙️ Installation

### 1. Cloner le dépôt

```bash
git clone https://github.com/votre-utilisateur/puit-de-log-glf.git
cd puit-de-log-glf
```
2. Lancer le script d’installation

Ce script :

    Crée le réseau Docker lokinet si besoin

    Applique les permissions nécessaires (UID/GID)

    Lance tous les conteneurs avec docker-compose

```bash
chmod +x setup.sh
./setup.sh
```

---

🔐 Reverse Proxy (facultatif)

Le dossier reverseproxy/conf.d/nginx.conf contient un exemple de configuration Nginx avec redirection HTTPS.
⚠️ Tu dois personnaliser :

    server_name

    Chemin vers les certificats SSL (certs/)

---

🌍 Accès aux interfaces

    Grafana : http://localhost:3000
    (ou via ton reverse proxy si configuré)

---

🧾 Notes

    Aucun volume Docker n’est utilisé : bind mounts uniquement

    Tu peux adapter les labels dans fluent-bit.conf selon tes besoins

    loki et grafana écrivent dans DATA/, tout est versionnable / portable
