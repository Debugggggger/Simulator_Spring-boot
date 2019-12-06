package com.drimsys.simulator.systemtray;

import java.awt.*;
import java.awt.event.ActionListener;

public class TrayIconHandler {
    private static TrayIcon trayIcon;

    public static void registerTrayIcon(Image image, String toolTip, ActionListener action) {
        if (SystemTray.isSupported()) {
            if (trayIcon != null) {
                trayIcon = null;
            }
            trayIcon = new TrayIcon(image);
            trayIcon.setImageAutoSize(true);

            if (toolTip != null) {
                trayIcon.setToolTip(toolTip);
            }

            if (action != null) {
                trayIcon.addActionListener(action);
            }

            try {
                for (TrayIcon registeredTrayIcon : SystemTray.getSystemTray()
                        .getTrayIcons()) {
                    SystemTray.getSystemTray().remove(registeredTrayIcon);
                }

                SystemTray.getSystemTray().add(trayIcon);
            } catch (AWTException e) {
                e.printStackTrace();
            }
        }
    }

    private static PopupMenu getPopupMenu() {
        PopupMenu popupMenu = trayIcon.getPopupMenu();

        if (popupMenu == null) {
            popupMenu = new PopupMenu();
        }

        return popupMenu;
    }

    private static void add(MenuItem item) {
        if (isNotRegistered()) {
            return;
        }

        PopupMenu popupMenu = getPopupMenu();
        popupMenu.add(item);

        trayIcon.setPopupMenu(popupMenu);
    }

    public static boolean isRegistered() {
        return (trayIcon != null && getPopupMenu() != null) ? true : false;
    }

    public static boolean isNotRegistered() {
        return !isRegistered();
    }

    public static void addItem(String label, ActionListener action) {
        MenuItem menuItem = new MenuItem(label);
        menuItem.addActionListener(action);

        add(menuItem);
    }

    public static void displayMessage(String caption, String text, TrayIcon.MessageType messageType) {
        if (isNotRegistered()) {
            return;
        }

        trayIcon.displayMessage(caption, text, messageType);
    }
}
