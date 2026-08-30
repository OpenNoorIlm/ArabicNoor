import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0

Rectangle {
    id: aboutSarfRoot
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"

    Label {
        id: aboutSarfLbl
        text: "📖 About Sarf Subject"
        color: "#c9a84c"
        font.pixelSize: 28
        font.bold: true
        z: 2
    }

    Timeline {
        id: timeline
        animations: [ TimelineAnimation { id: dropAnim; pingPong: false; running: true; loops: 1; to: 70; from: 0; duration: 1200 } ]
        startFrame: 0; endFrame: 70; enabled: true

        KeyframeGroup {
            target: aboutSarfLbl; property: "x"
            Keyframe { value: aboutSarfRoot.width * 0.5 - aboutSarfLbl.width * 0.5; frame: 0 }
            Keyframe { value: aboutSarfRoot.width * 0.5 - aboutSarfLbl.width * 0.5; frame: 60 }
            Keyframe { value: Math.max(16, aboutSarf.width - headingLbl.width - 24); frame: 70 }
        }
        KeyframeGroup {
            target: aboutSarfLbl; property: "y"
            Keyframe { value: -aboutSarfLbl.height; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: aboutSarfRoot.height * 0.5 - aboutSarfLbl.height * 0.5; frame: 60 }
            Keyframe { value: 24; frame: 70 }
        }
        KeyframeGroup {
            target: aboutSarfLbl; property: "opacity"
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
            width: aboutSarfRoot.width - 80
            spacing: 0

            // ENGLISH
            AnimBlock { blockText: "🇬🇧  English"; isHeading: true; textColor: "#ffffff"; animDelay: 200 }
            ContentDivider {}
            AnimBlock { blockText: "What is Sarf Subject?"; isHeading: true; animDelay: 300 }
            AnimBlock { blockText: "Sarf means the science of word morphology in Arabic grammar, or the act of spending and using in Urdu and Persian."; animDelay: 420 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "What book did we choose for Sarf?"; isHeading: true; animDelay: 540 }
            AnimBlock { blockText: "For Sarf we didn't choose any book — same as Nahw, we simply refer to the <b><font color='#ffffff'>Arabic book (دروس اللغة العربية)</font></b> and explain according to its chapters."; animDelay: 660 }
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
            AnimBlock { blockText: "ما هو موضوع \"الصرف\"؟"; isHeading: true; isArabic: true; animDelay: 1100 }
            AnimBlock { blockText: "يُشير مصطلح \"الصرف\" في قواعد اللغة العربية إلى علم بنية الكلمة وتشكيلها، بينما يحمل في اللغتين الأردية والفارسية معنى الإنفاق أو الاستخدام."; isArabic: true; animDelay: 1200 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "ما هو الكتاب الذي اخترناه لمادة الصرف؟"; isHeading: true; isArabic: true; animDelay: 1300 }
            AnimBlock { blockText: "لم نعتمد كتاباً منفصلاً لمادة الصرف، بل نكتفي بالرجوع إلى <b><font color='#ffffff'>كتاب اللغة العربية (دروس اللغة العربية)</font></b> ونقدم الشرح وفقاً للفصول الواردة فيه."; isArabic: true; animDelay: 1420 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "لماذا نعتمد هذا الأسلوب؟"; isHeading: true; isArabic: true; animDelay: 1540 }
            AnimBlock { blockText: "لأن هذا النهج يتكامل فعلياً مع مادة اللغة العربية، مما يعزز فهمك للمادة؛ إذ يتبع تسلسل الفصول الموجودة في <b><font color='#ffffff'>كتاب اللغة العربية (دروس اللغة العربية)</font></b>."; isArabic: true; animDelay: 1660 }
            Item { width: 1; height: 40 }
            ContentDivider {}
            ContentDivider {}
            Item { width: 1; height: 20 }

            // URDU
            AnimBlock { blockText: "🕌  اردو (گوگل کا ترجمہ)"; isHeading: true; isUrdu: true; textColor: "#ffffff"; animDelay: 1760 }
            ContentDivider {}
            AnimBlock { blockText: "'صرف' (Sarf) کا مضمون کیا ہے؟"; isHeading: true; isUrdu: true; animDelay: 1860 }
            AnimBlock { blockText: "عربی گرامر میں 'صرف' سے مراد الفاظ کی ساخت اور بناوٹ کا علم (word morphology) ہے، جبکہ اردو اور فارسی میں اس کا مطلب خرچ کرنا یا استعمال میں لانا ہے۔"; isUrdu: true; animDelay: 1960 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "ہم نے 'صرف' کے لیے کون سی کتاب منتخب کی ہے؟"; isHeading: true; isUrdu: true; animDelay: 2060 }
            AnimBlock { blockText: "'صرف' کے لیے ہم نے کوئی الگ کتاب منتخب نہیں کی؛ اس کے بجائے ہم اسی <b><font color='#ffffff'>عربی کتاب (دروس اللغۃ العربیۃ)</font></b> کا حوالہ دیتے ہیں اور اسی کے ابواب کے مطابق وضاحت کرتے ہیں۔"; isUrdu: true; animDelay: 2180 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "حوالہ کیوں دیا جاتا ہے؟"; isHeading: true; isUrdu: true; animDelay: 2300 }
            AnimBlock { blockText: "اس کی وجہ یہ ہے کہ یہ دراصل 'عربی' کے مضمون سے ہی منسلک ہے اور آپ کی سمجھ بوجھ میں اضافہ کرتا ہے، کیونکہ یہ <b><font color='#ffffff'>عربی کتاب (دروس اللغۃ العربیۃ)</font></b> کے ابواب کی ترتیب کی پیروی کرتا ہے۔"; isUrdu: true; animDelay: 2420 }
            Item { width: 1; height: 60 }
        }
    }
}
