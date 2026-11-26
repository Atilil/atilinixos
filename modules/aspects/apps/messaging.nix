{den, ...}: {
  # Group only; each app is also an aspect users can include on its own
  den.aspects.messaging.includes = with den.aspects; [
    telegram
    vesktop
    whatsapp
  ];
}
