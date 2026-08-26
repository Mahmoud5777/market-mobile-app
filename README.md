# Market — Application e-commerce full-stack (Flutter + Spring Boot + Big Data)

Application mobile e-commerce complète, développée de A à Z : navigation produits, panier, commandes, back-office admin, **pipeline de données temps réel (Kafka)**, **analyse et recommandations par Machine Learning (PySpark / Spark MLlib)**, et **dashboard de pilotage (React)** — le tout conteneurisé avec Docker.

Ce repo contient l'**application mobile Flutter**. Le projet complet est réparti sur 4 repos (voir [Architecture](#architecture--repos-du-projet) ci-dessous).

## Aperçu

| Client | Admin |
|---|---|
| _Ajoute tes captures d'écran ici_ | _Ajoute tes captures d'écran ici_ |

## Fonctionnalités

**Côté client**
- Navigation libre sans compte (comme une vraie app marchande)
- Connexion demandée uniquement au moment d'ajouter au panier
- Panier, commande, paiement simulé
- Gestion de compte (nom, email, mot de passe)
- Section "Recommandé pour vous" alimentée par un modèle de Machine Learning

**Côté admin**
- Compte admin sécurisé (créé automatiquement, aucune auto-promotion possible)
- CRUD produits complet, upload d'image depuis la galerie
- Dashboard analytics séparé (React) : produits les plus consultés, taux de conversion, paniers abandonnés

## Stack technique

| Domaine | Technologies |
|---|---|
| Mobile | Flutter, Provider, JWT |
| Backend | Spring Boot 3, Spring Security, Spring Data JPA, PostgreSQL |
| Streaming | Apache Kafka (mode KRaft, sans Zookeeper) |
| Big Data / ML | PySpark, Spark MLlib (ALS — filtrage collaboratif) |
| Dashboard | React, Recharts |
| Infra | Docker, Docker Compose |

## Architecture & repos du projet
┌──────────────┐ ┌──────────────────┐ ┌────────────┐
│ App Flutter │ ───▶ │ Backend Spring │ ───▶ │ PostgreSQL │
│ (ce repo) │ ◀─── │ Boot (API REST) │ ◀─── │ │
└──────────────┘ └────────┬──────────┘ └─────┬──────┘
│ événements │
▼ ▼
┌──────────┐ ┌───────────────┐
│ Kafka │ ◀── lu ── │ PySpark/Jupyter│
└──────────┘ │ (agrégations, │
│ ALS) │
└───────┬────────┘
▼
┌───────────────────┐
│ Dashboard React │
└───────────────────┘

| Repo | Rôle |
|---|---|
| **market-mobile-app** (ce repo) | Application Flutter (client + admin) |
| [market-backend](https://github.com/Mahmoud5777/market-backend) | API REST Spring Boot : auth JWT, produits, panier, commandes, publication d'événements Kafka |
| [market-infra](https://github.com/Mahmoud5777/market-infra) | Orchestration Docker : Kafka, PySpark/Jupyter, scripts d'agrégation et de recommandation ML |
| [market-dashboard](https://github.com/Mahmoud5777/market-dashboard) | Dashboard React de visualisation des analytics (admin) |

## Lancer le projet

Le projet complet nécessite les 4 repos. Voir le README de chacun pour les instructions détaillées. Résumé :

```bash
# 1. Backend + Kafka + PySpark + Dashboard (voir market-infra)
cd market-infra
docker-compose up -d

# 2. App Flutter (ce repo)
flutter pub get
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
```

## Sécurité

- Mots de passe hashés en BCrypt
- JWT signé, expiration configurable
- Aucune donnée de carte bancaire réelle stockée (paiement simulé)
- Aucun endpoint public pour s'auto-promouvoir administrateur
