import 'package:flutter/material.dart';
import 'package:rescue_terminal/components/widget_default_btn.dart';

class UpdateSetting extends StatefulWidget {
  const UpdateSetting({super.key});

  @override
  State<UpdateSetting> createState() => _UpdateSettingState();
}

class _UpdateSettingState extends State<UpdateSetting> {
  // 默认展示配置
  Widget widgetConfigurationDisplay() {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              child: const Text(
                '发现新版本',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              child: const Text(
                '当前版本：V1.0.0',
              ),
            ),
            WidgetDefaultBtn(
              name: '立即更新',
              callback: () {},
              width: 120,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 14, left: 30, bottom: 30),
            child: Text('版本更新'),
          ),
          widgetConfigurationDisplay()
        ],
      ),
    );
  }
}
