require_relative "item_manager"
require_relative "ownable"
include Ownable
class Cart
  include ItemManager

  def initialize(owner)
    self.owner = owner
    @items = []
  end

  def items
    @items
  end

  def add(item)
    @items << item
  end

  def total_amount
    @items.sum(&:price)
  end

  def check_out
    return if owner.wallet.balance < total_amount

    # Transférer le montant d'achat du portefeuille du propriétaire du panier au portefeuille du propriétaire de l'article
    @items.each do |item|
      item_owner_wallet = item.owner.wallet
      owner_wallet = owner.wallet

      # Vérifier si le portefeuille du propriétaire du panier a suffisamment de fonds
      if owner_wallet.balance >= item.price
        # Retirer le montant du portefeuille du propriétaire du panier
        owner_wallet.withdraw(item.price)

        # Déposer le montant dans le portefeuille du propriétaire de l'article
        item_owner_wallet.deposit(item.price)

        # Transférer les droits de propriété de l'article au propriétaire du panier
        item.owner = owner
      end
    end

    # Vider le panier
    @items = []
  end
end
