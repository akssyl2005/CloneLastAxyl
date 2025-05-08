import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Centre d'Aide"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SectionTitle("👤 Mon Compte"),
          HelpItem(
            "Comment créer un compte ?",
            "Appuyez sur 'S'inscrire' sur l'écran de connexion, remplissez les champs et validez.",
          ),
          HelpItem(
            "J’ai oublié mon mot de passe",
            "Appuyez sur 'Mot de passe oublié ?' sur la page de connexion et suivez les instructions.",
          ),
          HelpItem(
            "Comment modifier mes informations ?",
            "Allez dans la section Profil, puis cliquez sur 'Modifier'.",
          ),
          HelpItem(
            "Comment supprimer mon compte ?",
            "Veuillez contacter le support via e-mail pour effectuer cette action.",
          ),

          SectionTitle("🛍 Commandes"),
          HelpItem(
            "Comment passer une commande ?",
            "Ajoutez les articles au panier, puis appuyez sur 'Commander'. Suivez les étapes.",
          ),
          HelpItem(
            "Où puis-je voir mes commandes ?",
            "Rendez-vous dans la section 'Mes commandes' sur votre profil.",
          ),
          HelpItem(
            "Puis-je annuler une commande ?",
            "Vous pouvez annuler une commande si elle n’a pas encore été expédiée. Contactez-nous rapidement.",
          ),

          SectionTitle("💳 Paiement"),
          HelpItem(
            "Quels moyens de paiement sont acceptés ?",
            "Carte bancaire, PayPal, et paiement à la livraison selon votre région.",
          ),
          HelpItem(
            "Le paiement a échoué, que faire ?",
            "Vérifiez vos informations de carte ou contactez votre banque. Sinon, essayez un autre mode de paiement.",
          ),
          HelpItem(
            "Puis-je payer à la livraison ?",
            "Oui, le paiement à la livraison est disponible dans certaines zones.",
          ),

          SectionTitle("🚚 Livraison"),
          HelpItem(
            "Quels sont les délais de livraison ?",
            "Les livraisons prennent généralement entre 3 à 7 jours ouvrables.",
          ),
          HelpItem(
            "Comment suivre ma commande ?",
            "Une fois expédiée, un lien de suivi sera disponible dans 'Mes commandes'.",
          ),
          HelpItem(
            "Ma commande est en retard",
            "Veuillez patienter 1 à 2 jours supplémentaires, ou contactez notre support.",
          ),

          SectionTitle("📦 Retours & Remboursements"),
          HelpItem(
            "Comment retourner un article ?",
            "Contactez-nous via e-mail avec une photo de l’article. Nous vous guiderons.",
          ),
          HelpItem(
            "Dans combien de temps serai-je remboursé ?",
            "Les remboursements prennent jusqu’à 7 jours après réception du retour.",
          ),
          HelpItem(
            "Puis-je échanger un produit ?",
            "Oui, sous 14 jours et si l’article est en bon état. Contactez le support.",
          ),

          SectionTitle("📞 Support"),
          HelpItem(
            "Comment contacter le service client ?",
            "Envoyez-nous un e-mail à support@votreapp.com ou appelez le 0123-456-789.",
          ),
          HelpItem(
            "Horaires du service client",
            "Du lundi au vendredi, de 9h à 17h.",
          ),
        ],
      ),
    );
  }
}

class HelpItem extends StatelessWidget {
  final String question;
  final String answer;

  const HelpItem(this.question, this.answer, {super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(answer),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
