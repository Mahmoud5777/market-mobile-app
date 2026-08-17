class Product {
  final int id;
  final int price;
  final String title;
  final String subTitle;
  final String description;
  final String image;

  const Product({
    required this.id,
    required this.price,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.image,
  });
}

// list of products
List<Product> products = [
  Product(
    id: 1,
    price: 59,
    title: "Écouteurs sans fil",
    subTitle: "Haute qualité sonore",
    image: "images/airpod.png",
    description:
        "Profitez d'un son cristallin et d'une liberté totale sans fil grâce à ces écouteurs au design moderne. Idéals pour vos déplacements, vos appels et vos séances de sport.",
  ),
  Product(
    id: 2,
    price: 1099,
    title: "Téléphone mobile",
    subTitle: "La puissance entre vos mains",
    image: "images/mobile.png",
    description:
        "Un smartphone haut de gamme avec des performances impressionnantes, une autonomie longue durée et un écran immersif. Capturez chaque instant avec sa caméra ultra claire.",
  ),
  Product(
    id: 3,
    price: 39,
    title: "Lunettes 3D",
    subTitle: "Plongez dans la réalité virtuelle",
    image: "images/class.png",
    description:
        "Découvrez des mondes immersifs avec ces lunettes 3D conçues pour le confort et la clarté visuelle. Parfaites pour les films, jeux et expériences VR.",
  ),
  Product(
    id: 4,
    price: 56,
    title: "Casque audio",
    subTitle: "Pour de longues heures d’écoute",
    image: "images/headset.png",
    description:
        "Un casque confortable avec une qualité sonore exceptionnelle, parfait pour le gaming, la musique ou le télétravail. Isolation phonique incluse.",
  ),
  Product(
    id: 5,
    price: 68,
    title: "Enregistreur vocal",
    subTitle: "Capturez les moments importants",
    image: "images/speaker.png",
    description:
        "Compact et facile à utiliser, cet enregistreur vocal est idéal pour les étudiants, journalistes ou professionnels souhaitant enregistrer des notes ou interviews.",
  ),
  Product(
    id: 6,
    price: 39,
    title: "Webcam",
    subTitle: "Image claire et nette",
    image: "images/camera.png",
    description:
        "Améliorez vos visioconférences avec cette webcam haute résolution. Facile à installer, elle offre une excellente qualité d’image et de son.",
  ),
  Product(
    id: 7,
    price: 249,
    title: "Montre connectée",
    subTitle: "Votre santé à portée de main",
    image: "images/smartwatch.png",
    description:
        "Suivez votre activité physique, recevez vos notifications et surveillez votre rythme cardiaque en temps réel grâce à cette montre élégante et performante.",
  ),
  Product(
    id: 8,
    price: 89,
    title: "Clavier mécanique",
    subTitle: "Confort et réactivité",
    image: "images/keyboard.png",
    description:
        "Un clavier mécanique avec éclairage RGB pour une frappe rapide et agréable. Parfait pour les gamers et les développeurs.",
  ),
  Product(
    id: 9,
    price: 129,
    title: "Drone caméra",
    subTitle: "Vues aériennes exceptionnelles",
    image: "images/drone.png",
    description:
        "Prenez des photos et vidéos aériennes spectaculaires avec ce drone facile à piloter. Idéal pour les amateurs de paysages ou les créateurs de contenu.",
  ),
  Product(
    id: 10,
    price: 45,
    title: "Chargeur sans fil",
    subTitle: "Recharge rapide et pratique",
    image: "images/wireless_charger.png",
    description:
        "Placez simplement votre appareil pour le recharger rapidement. Compatible avec tous les smartphones supportant la charge sans fil.",
  ),
  Product(
    id: 11,
    price: 74,
    title: "Lampe LED ",
    subTitle: "L'ambiance parfaite à tout moment",
    image: "images/smart_lamp.png",
    description:
        "Contrôlez la lumière de votre pièce depuis votre téléphone. Changez les couleurs, programmez des horaires et créez des ambiances sur mesure.",
  ),
  Product(
    id: 12,
    price: 35,
    title: "Souris sans fil",
    subTitle: "Précise et ergonomique",
    image: "images/wireless_mouse.png",
    description:
        "Conçue pour le confort et la performance, cette souris sans fil vous offre une navigation fluide et précise, idéale pour le travail ou le jeu.",
  ),
  Product(
    id: 13,
    price: 220,
    title: "Tablette graphique",
    subTitle: "Pour les artistes numériques",
    image: "images/graphic_tablet.png",
    description:
        "Dessinez, esquissez ou retouchez avec précision grâce à cette tablette graphique sensible à la pression. Compatible avec tous les logiciels créatifs.",
  ),
  Product(
    id: 14,
    price: 149,
    title: "Mini projecteur",
    subTitle: "Le cinéma chez vous",
    image: "images/mini_projector.png",
    description:
        "Transformez n'importe quel mur en écran géant. Compact et facile à utiliser, ce projecteur est parfait pour les soirées cinéma ou les présentations.",
  ),
  Product(
    id: 15,
    price: 89,
    title: "Microphone USB",
    subTitle: "Son clair et professionnel",
    image: "images/usb_microphone.png",
    description:
        "Que ce soit pour des podcasts, des vidéos ou des réunions, ce micro USB garantit une captation sonore nette avec un minimum de bruit.",
  ),
  Product(
    id: 16,
    price: 199,
    title: "Casque VR",
    subTitle: "Immersion totale",
    image: "images/vr_headset.png",
    description:
        "Plongez dans un monde virtuel avec ce casque VR haute résolution. Compatible avec plusieurs plateformes pour une expérience de jeu unique.",
  ),
];
