import 'package:quick_actions/quick_actions.dart';

class QuickActionHelper{
  void setupQuickActions(){
    final QuickActions quickActions = QuickActions();
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'action_1', localizedTitle: 'Open'),
      const ShortcutItem(type: 'action_2', localizedTitle: 'Due Today'),
      const ShortcutItem(type: 'action_3', localizedTitle: 'Priority'),
      const ShortcutItem(type: 'action_5', localizedTitle: 'Due Date'),
    ]);

}


  String computeQuickActions(){
    String qaOrder;
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      switch (shortcutType) {
        case 'action_2':
          {
            qaOrder = 'today';
          }
          break;
        case 'action_3':
          {
            qaOrder = 'asc';
          }
          break;
        case 'action_4':
          {
            qaOrder = 'aasc';
          }
          break;
        case 'action_5':
          {
            qaOrder = 'dueasc';
          }
          break;
        case 'action_6':
          {
            qaOrder = 'adsc';
          }
          break;
        case 'action_7':
          {
            qaOrder = 'duedsc';
          }
          break;
        case 'action_8':
          {
            qaOrder = 'normal';
          }
          break;
        default:
          {
            //just open the app
          }
          break;
      }
    });


    return qaOrder;
  }
}