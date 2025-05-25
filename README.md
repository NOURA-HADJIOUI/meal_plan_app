# meal_plan_app
# 🍽️ YumPlan - Gestionnaire de Menu Hebdomadaire

Une application mobile intuitive pour planifier et gérer vos menus de la semaine en toute simplicité.

## 📱 Aperçu

 YumPlan est une application de gestion de menu qui vous permet d'organiser vos repas quotidiens, de suivre vos préférences culinaires et d'optimiser votre planification alimentaire hebdomadaire.

## ✨ Fonctionnalités

### 🗓️ Gestion des Repas
- **Planification quotidienne** : Ajoutez jusqu'à 2 repas par jour (déjeuner et dîner)
- **Catégorisation** : Organisez vos repas par catégorie (Entrée, Plat, Dessert)
- **Informations détaillées** : Nom, description et image pour chaque repas
- **Planification multiple** : Ajoutez le même repas à plusieurs jours simultanément

### 📅 Affichage et Visualisation
- **Vue quotidienne** : Consultez le menu du jour en détail
- **Vue hebdomadaire** : Calendrier complet de la semaine
- **Export** : Générez des PDF ou images imprimables de vos menus

### ⭐ Évaluation et Suivi
- **Système de notation** : Évaluez vos repas avec un système d'étoiles
- **Commentaires personnalisés** : Ajoutez des notes comme "tout le monde a aimé sauf Ahmed"
- **Historique complet** : Accédez à l'historique de tous vos repas pour éviter les répétitions

### 🎲 Fonctionnalités Avancées
- **Mode aléatoire** : Génération automatique de suggestions de repas
- **Anti-répétition** : Système intelligent pour varier vos menus

## 🛠️ Technologies Utilisées

```
Frontend Mobile:
- Flutter
- UI Components: Figma

Backend: Firebase
- Base de données:  Firestore
- Authentification: Firebase Auth

Fonctionnalités:
- Génération PDF: jsPDF / pdf-lib
- Gestion d'images:  Firebase Storage
```

## 📋 Prérequis
-Vs code (pour le développement mobile)
- Compte Firebase (optionnel)

## 🚀 Installation

1. **Cloner le repository**
```bash
git clone https://github.com/username/menuweek-app.git
cd menuweek-app
```

2. **Installer les dépendances**
```bash
npm install
# ou
yarn install
```

3. **Configuration de l'environnement**
```bash
cp .env.example .env
# Configurer les variables d'environnement
```

4. **Démarrer l'application**
```bash
# Pour Android
npm run android

# Pour iOS
npm run ios

# Mode développement web
npm run web
```

## 📖 Guide d'Utilisation

### Ajouter un Repas
1. Sélectionnez le jour souhaité
2. Choisissez le type de repas (déjeuner/dîner)
3. Sélectionnez la catégorie (entrée/plat/dessert)
4. Remplissez les informations : nom, description, image
5. Sauvegardez

### Planifier la Semaine
1. Utilisez la vue calendrier
2. Glissez-déposez les repas vers les jours souhaités
3. Ou utilisez le mode aléatoire pour des suggestions automatiques

### Évaluer un Repas
1. Après avoir consommé le repas
2. Cliquez sur l'icône étoile
3. Attribuez une note de 1 à 5 étoiles
4. Ajoutez un commentaire optionnel

## 📊 Structure du Projet

```
menuweek-app/
├── src/
│   ├── components/          # Composants réutilisables
│   ├── screens/            # Écrans de l'application
│   ├── navigation/         # Configuration de navigation
│   ├── services/           # Services API et logique métier
│   ├── store/             # Gestion d'état global
│   ├── utils/             # Utilitaires et helpers
│   └── assets/            # Images, fonts, icônes
├── docs/                  # Documentation
├── tests/                 # Tests unitaires et d'intégration
└── README.md
```

## 🧪 Tests

```bash
# Tests unitaires
npm run test

# Tests d'intégration
npm run test:integration

# Coverage
npm run test:coverage
```

## 📸 Captures d'Écran

| Vue Calendrier | Ajout de Repas | Évaluation |
|----------------|----------------|------------|
| ![Calendar](./docs/screenshots/calendar.png) | ![Add Meal](./docs/screenshots/add-meal.png) | ![Rating](./docs/screenshots/rating.png) |

## 🔄 Roadmap

- [ ] **v1.0** - Fonctionnalités de base
  - [x] Gestion des repas quotidiens
  - [x] Vue calendrier
  - [ ] Export PDF/Image
  - [ ] Système de notation

- [ ] **v1.1** - Fonctionnalités avancées
  - [ ] Mode aléatoire intelligent
  - [ ] Historique et statistiques
  - [ ] Synchronisation cloud

- [ ] **v2.0** - Fonctionnalités communautaires
  - [ ] Partage de menus
  - [ ] Suggestions basées sur l'IA
  - [ ] Intégration avec les courses

## 🤝 Contribution

Les contributions sont les bienvenues ! Consultez notre [Guide de Contribution](CONTRIBUTING.md).

1. Fork le projet
2. Créez une branche feature (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📝 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Équipe

- **[Votre Nom]** - *Développeur Principal* - [@username](https://github.com/username)

## 📞 Support

- 📧 Email: support@menuweek.app
- 🐛 Issues: [GitHub Issues](https://github.com/username/menuweek-app/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/username/menuweek-app/discussions)

## 🙏 Remerciements

- [Icônes par Heroicons](https://heroicons.com/)
- [Images par Unsplash](https://unsplash.com/)
- Communauté React Native

---

⭐ **N'oubliez pas de mettre une étoile si ce projet vous a aidé !**
