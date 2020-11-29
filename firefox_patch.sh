#!/bin/sh

cp /usr/lib/firefox/browser/omni.ja /tmp/omni.ja
cd /tmp
unzip -q omni.ja -d firefox_omni

patch -p0 <<EOF
--- /dev/null	2010-01-01 00:00:00.000000000 +0100
+++ firefox_omni/chrome/browser/content/browser/browser.xhtml	2020-05-10 21:11:24.263816637 +0200
@@ -280,6 +280,11 @@
          modifiers="accel" reserved="true"/>
     <key id="key_newNavigatorTab" data-l10n-id="tab-new-shortcut" modifiers="accel"
          command="cmd_newNavigatorTabNoEvent" reserved="true"/>
+
+    <key id="custom_prevTab" key="k" modifiers="accel" oncommand="gBrowser.tabContainer.advanceSelectedTab(-1, true);" reserved="true"/>
+    <key id="custom_nextTab" key="j" modifiers="accel" oncommand="gBrowser.tabContainer.advanceSelectedTab(1, true);" reserved="true"/>
+    <key id="custom_focusTab" key="e" modifiers="accel" oncommand="window.focus();" reserved="true"/>
+
     <key id="focusURLBar" data-l10n-id="location-open-shortcut" command="Browser:OpenLocation"
          modifiers="accel"/>
     <key id="focusURLBar2" data-l10n-id="location-open-shortcut-alt" command="Browser:OpenLocation"
@@ -390,15 +395,15 @@
     <key id="key_undoCloseWindow" command="History:UndoCloseWindow" data-l10n-id="window-new-shortcut" modifiers="accel,shift"/>
 
 
-<key id="key_selectTab1" oncommand="gBrowser.selectTabAtIndex(0, event);" key="1" modifiers="alt"/>
-<key id="key_selectTab2" oncommand="gBrowser.selectTabAtIndex(1, event);" key="2" modifiers="alt"/>
-<key id="key_selectTab3" oncommand="gBrowser.selectTabAtIndex(2, event);" key="3" modifiers="alt"/>
-<key id="key_selectTab4" oncommand="gBrowser.selectTabAtIndex(3, event);" key="4" modifiers="alt"/>
-<key id="key_selectTab5" oncommand="gBrowser.selectTabAtIndex(4, event);" key="5" modifiers="alt"/>
-<key id="key_selectTab6" oncommand="gBrowser.selectTabAtIndex(5, event);" key="6" modifiers="alt"/>
-<key id="key_selectTab7" oncommand="gBrowser.selectTabAtIndex(6, event);" key="7" modifiers="alt"/>
-<key id="key_selectTab8" oncommand="gBrowser.selectTabAtIndex(7, event);" key="8" modifiers="alt"/>
-<key id="key_selectLastTab" oncommand="gBrowser.selectTabAtIndex(-1, event);" key="9" modifiers="alt"/>
+<key id="key_selectTab1" oncommand="gBrowser.selectTabAtIndex(0, event);" key="1" modifiers="accel"/>
+<key id="key_selectTab2" oncommand="gBrowser.selectTabAtIndex(1, event);" key="2" modifiers="accel"/>
+<key id="key_selectTab3" oncommand="gBrowser.selectTabAtIndex(2, event);" key="3" modifiers="accel"/>
+<key id="key_selectTab4" oncommand="gBrowser.selectTabAtIndex(3, event);" key="4" modifiers="accel"/>
+<key id="key_selectTab5" oncommand="gBrowser.selectTabAtIndex(4, event);" key="5" modifiers="accel"/>
+<key id="key_selectTab6" oncommand="gBrowser.selectTabAtIndex(5, event);" key="6" modifiers="accel"/>
+<key id="key_selectTab7" oncommand="gBrowser.selectTabAtIndex(6, event);" key="7" modifiers="accel"/>
+<key id="key_selectTab8" oncommand="gBrowser.selectTabAtIndex(7, event);" key="8" modifiers="accel"/>
+<key id="key_selectLastTab" oncommand="gBrowser.selectTabAtIndex(-1, event);" key="9" modifiers="accel"/>
 
     <key id="key_wrCaptureCmd"
     key="#" modifiers="control"
EOF

cd firefox_omni
zip -qr9XD ../omni.ja.new *

cd ..
rm -rf firefox_omni
find ~/.cache/mozilla/firefox -type d -name startupCache | xargs rm -rf

sudo mv omni.ja.new /usr/lib/firefox/browser/omni.ja

find ~/.cache/mozilla/firefox -type d -name startupCache | xargs rm -rf
