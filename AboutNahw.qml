import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0
import QtQuick.Studio.DesignEffects

Rectangle {
    id: aboutNahwRoot
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"

    Label {
        id: aboutNahwLbl
        text: "📖 About Nahw Subject"
        color: "#c9a84c"
        font.pixelSize: 28
        font.bold: true
        z: 2
        DesignEffect { effects: [ DesignDropShadow { color: "#80c9a84c" } ] }
    }

    Timeline {
        id: timeline
        animations: [ TimelineAnimation { id: dropAnim; pingPong: false; running: true; loops: 1; to: 70; from: 0; duration: 1200 } ]
        startFrame: 0; endFrame: 70; enabled: true

        KeyframeGroup {
            target: aboutNahwLbl; property: "x"
            Keyframe { value: aboutNahwRoot.width * 0.5 - aboutNahwLbl.width * 0.5; frame: 0 }
            Keyframe { value: aboutNahwRoot.width * 0.5 - aboutNahwLbl.width * 0.5; frame: 60 }
            Keyframe { value: 883; frame: 70 }
        }
        KeyframeGroup {
            target: aboutNahwLbl; property: "y"
            Keyframe { value: -aboutNahwLbl.height; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: aboutNahwRoot.height * 0.5 - aboutNahwLbl.height * 0.5; frame: 60 }
            Keyframe { value: 24; frame: 70 }
        }
        KeyframeGroup {
            target: aboutNahwLbl; property: "opacity"
            Keyframe { value: 0; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: 1; frame: 60 }
        }
    }

    ScrollView {
        anchors.top: parent.top; anchors.topMargin: 70
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        anchors.leftMargin: 40; anchors.rightMargin: 40
        clip: true

        Column {
            width: aboutNahwRoot.width - 80
            spacing: 0

            // ENGLISH
            AnimBlock { blockText: "🇬🇧  English"; isHeading: true; textColor: "#ffffff"; animDelay: 200 }
            ContentDivider {}
            AnimBlock { blockText: "What is Nahw Subject?"; isHeading: true; animDelay: 300 }
            AnimBlock { blockText: "Nahw (النحو) means Arabic syntax, which is the study of sentence structure and how word endings change based on a word's role in a sentence."; animDelay: 420 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "What book did we choose for Nahw?"; isHeading: true; animDelay: 540 }
            AnimBlock { blockText: "For Nahw we didn't choose any book — we simply refer to the <b><font color='#ffffff'>Arabic book (دروس اللغة العربية)</font></b> and explain according to its chapters."; animDelay: 660 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "Why refer?"; isHeading: true; animDelay: 780 }
            AnimBlock { blockText: "Because it actually goes with the Arabic subject, making you understand more as it follows the chapters of the <b><font color='#ffffff'>Arabic book (دروس اللغة العربية)</font></b>."; animDelay: 900 }
            Item { width: 1; height: 40 }
            ContentDivider {}
            ContentDivider {}
            Item { width: 1; height: 20 }

            // ARABIC
            AnimBlock { blockText: "🌙  العربية (مترجمة بواسطة Google)"; isHeading: true; isArabic: true; textColor: "#ffffff"; animDelay: 1000 }
            ContentDivider {}
            AnimBlock { blockText: "ما هي مادة النحو؟"; isHeading: true; isArabic: true; animDelay: 1100 }
            AnimBlock { blockText: "يُقصد بـ \"النحو\" قواعد اللغة العربية، وهو العلم الذي يدرس تركيب الجملة وكيفية تغير أواخر الكلمات بناءً على دورها وموقعها داخل الجملة."; isArabic: true; animDelay: 1200 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "ما هو الكتاب الذي اخترناه لمادة النحو؟"; isHeading: true; isArabic: true; animDelay: 1300 }
            AnimBlock { blockText: "لم نعتمد كتاباً خاصاً لمادة النحو؛ بل نكتفي بالرجوع إلى <b><font color='#ffffff'>كتاب اللغة العربية (دروس اللغة العربية)</font></b> ونقدم الشرح وفقاً للفصول الواردة فيه."; isArabic: true; animDelay: 1420 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "لماذا نعتمد هذا الأسلوب؟"; isHeading: true; isArabic: true; animDelay: 1540 }
            AnimBlock { blockText: "لأن هذا النهج يتكامل فعلياً مع مادة اللغة العربية، مما يعزز فهمك للمادة، حيث يسير الشرح بالتوازي مع فصول <b><font color='#ffffff'>كتاب اللغة العربية (دروس اللغة العربية)</font></b>."; isArabic: true; animDelay: 1660 }
            Item { width: 1; height: 40 }
            ContentDivider {}
            ContentDivider {}
            Item { width: 1; height: 20 }

            // URDU
            AnimBlock { blockText: "🕌  اردو (گوگل کا ترجمہ)"; isHeading: true; isUrdu: true; textColor: "#ffffff"; animDelay: 1760 }
            ContentDivider {}
            AnimBlock { blockText: "'نحو' (Nahw) کا مضمون کیا ہے؟"; isHeading: true; isUrdu: true; animDelay: 1860 }
            AnimBlock { blockText: "'نحو' (النحو) سے مراد عربی زبان کا وہ شعبہ ہے جو جملے کی ساخت اور اس بات کا مطالعہ کرتا ہے کہ جملے میں کسی لفظ کے کردار کی بنیاد پر اس کے آخری حصے (اعراب) میں کیا تبدیلی آتی ہے۔"; isUrdu: true; animDelay: 1960 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "ہم نے 'نحو' کے لیے کون سی کتاب منتخب کی ہے؟"; isHeading: true; isUrdu: true; animDelay: 2060 }
            AnimBlock { blockText: "'نحو' کے لیے ہم نے کوئی الگ کتاب منتخب نہیں کی، بلکہ ہم اسی <b><font color='#ffffff'>عربی کتاب (دروس اللغۃ العربیۃ)</font></b> سے رجوع کرتے ہیں اور اسی کے ابواب کے مطابق وضاحت کرتے ہیں۔"; isUrdu: true; animDelay: 2180 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "اسی کتاب سے رجوع کیوں کیا جاتا ہے؟"; isHeading: true; isUrdu: true; animDelay: 2300 }
            AnimBlock { blockText: "اس کی وجہ یہ ہے کہ یہ دراصل 'عربی' کے مضمون کے ساتھ ہم آہنگ ہے اور آپ کو بہتر طور پر سمجھنے میں مدد دیتی ہے، کیونکہ یہ <b><font color='#ffffff'>عربی کتاب (دروس اللغۃ العربیۃ)</font></b> کے ابواب کی ترتیب کی پیروی کرتی ہے۔"; isUrdu: true; animDelay: 2420 }
            Item { width: 1; height: 60 }
        }
    }

    DesignEffect { effects: [ DesignInnerShadow { } ] }
}
