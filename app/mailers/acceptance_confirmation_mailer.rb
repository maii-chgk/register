class AcceptanceConfirmationMailer < ApplicationMailer
  def send_confirmation(email)
    mail(to: email,
         subject: "Ура! Теперь вы входите в МАИИ")
  end
end
