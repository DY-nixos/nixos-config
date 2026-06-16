#include <noctalia.h>

class Config : public NoctaliaConfig {
public:
    Config() {
        // 设置语言为简体中文
        language = "zh_CN";
        
        // 设置中文字体（确保系统已安装）
        ui.font = "Noto Sans CJK SC";
        ui.fontSize = 12;
        
        // 其他基本配置
        window.width = 1920;
        window.height = 1080;
    }
};

REGISTER_CONFIG(Config)
