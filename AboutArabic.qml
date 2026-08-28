import QtQuick
import QtQuick.Controls
import QtQuick.Timeline 1.0
import QtQuick.Studio.DesignEffects

Rectangle {
    id: aboutArabicRoot
    width: parent ? parent.width : Screen.width
    height: parent ? parent.height : Screen.height
    color: "#1a1a2e"

    Label {
        id: aboutArabicLbl
        text: "📖 About Arabic Subject"
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
            target: aboutArabicLbl; property: "x"
            Keyframe { value: aboutArabicRoot.width * 0.5 - aboutArabicLbl.width * 0.5; frame: 0 }
            Keyframe { value: aboutArabicRoot.width * 0.5 - aboutArabicLbl.width * 0.5; frame: 60 }
            Keyframe { value: 883; frame: 70 }
        }
        KeyframeGroup {
            target: aboutArabicLbl; property: "y"
            Keyframe { value: -aboutArabicLbl.height; frame: 0 }
            Keyframe { easing.type: Easing.OutCubic; value: aboutArabicRoot.height * 0.5 - aboutArabicLbl.height * 0.5; frame: 60 }
            Keyframe { value: 24; frame: 70 }
        }
        KeyframeGroup {
            target: aboutArabicLbl; property: "opacity"
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
            width: aboutArabicRoot.width - 80
            spacing: 0

            // ENGLISH
            AnimBlock { blockText: "🇬🇧  English"; isHeading: true; textColor: "#ffffff"; animDelay: 200 }
            ContentDivider {}
            AnimBlock { blockText: "What is the Arabic subject?"; isHeading: true; animDelay: 300 }
            AnimBlock { blockText: "This subject gives you new words in Arabic and how to use the knowledge of Sarf and Nahw in reality, while giving you words to actually make <b><font color='#ffffff'>sentences</font></b>."; animDelay: 420 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "What book did we choose for the Arabic subject?"; isHeading: true; animDelay: 540 }
            AnimBlock { blockText: "For the Arabic Subject as a teaching purpose we chose <b><font color='#ffffff'>دروس اللغة العربية / duroosul lughatul arabia</font></b>. You could find the PDF/book anywhere, but the edition we use has about 4 parts which is the <b><font color='#ffffff'>sharah / شرح</font></b> of it."; animDelay: 660 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "Why that book?"; isHeading: true; animDelay: 780 }
            AnimBlock { blockText: "Because it has a lot of exercises and also a lot of words/sentences to practice on. Its sentences cover almost all Sarf and Nahw rules and grammar — from which you can practically apply your learned skills."; animDelay: 900 }
            Item { width: 1; height: 40 }
            ContentDivider {}
            ContentDivider {}
            Item { width: 1; height: 20 }

            // ARABIC
            AnimBlock { blockText: "🌙  العربية (مترجمة بواسطة Google)"; isHeading: true; isArabic: true; textColor: "#ffffff"; animDelay: 1000 }
            ContentDivider {}
            AnimBlock { blockText: "ما هي مادة اللغة العربية؟"; isHeading: true; isArabic: true; animDelay: 1100 }
            AnimBlock { blockText: "تُكسبك هذه المادة مفردات عربية جديدة وتُعلمك كيفية تطبيق قواعد الصرف والنحو عملياً، مع تزويدك بالكلمات اللازمة لتكوين <b><font color='#ffffff'>جمل</font></b> فعلية."; isArabic: true; animDelay: 1200 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "ما هو الكتاب الذي اخترناه لمادة اللغة العربية؟"; isHeading: true; isArabic: true; animDelay: 1300 }
            AnimBlock { blockText: "لأغراض التدريس، اخترنا كتاب <b><font color='#ffffff'>\"دروس اللغة العربية\"</font></b>؛ ورغم إمكانية العثور على نسخة منه في أماكن متعددة، إلا أن النسخة التي نعتمدها تتكون من أربعة أجزاء وتتضمن <b><font color='#ffffff'>شرحاً</font></b> وافياً للمادة."; isArabic: true; animDelay: 1420 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "لماذا اخترنا هذا الكتاب تحديداً؟"; isHeading: true; isArabic: true; animDelay: 1540 }
            AnimBlock { blockText: "لأنه يحتوي على وفرة من التمارين والمفردات والجمل المخصصة للتدريب، كما أن جمله تغطي كافة قواعد الصرف والنحو تقريباً، مما يتيح لك تطبيق المهارات التي اكتسبتها في هذين المجالين بشكل عملي ومباشر."; isArabic: true; animDelay: 1660 }
            Item { width: 1; height: 40 }
            ContentDivider {}
            ContentDivider {}
            Item { width: 1; height: 20 }

            // URDU
            AnimBlock { blockText: "🕌  اردو (گوگل کا ترجمہ)"; isHeading: true; isUrdu: true; textColor: "#ffffff"; animDelay: 1760 }
            ContentDivider {}
            AnimBlock { blockText: "عربی کا مضمون کیا ہے؟"; isHeading: true; isUrdu: true; animDelay: 1860 }
            AnimBlock { blockText: "یہ مضمون آپ کو عربی کے نئے الفاظ سکھاتا ہے اور یہ بتاتا ہے کہ 'صرف' اور 'نحو' کے علم کو عملی طور پر کیسے استعمال کیا جائے، ساتھ ہی یہ آپ کو ایسے الفاظ فراہم کرتا ہے جن سے آپ واقعی <b><font color='#ffffff'>جملے</font></b> بنا سکیں۔"; isUrdu: true; animDelay: 1960 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "ہم نے عربی کے مضمون کے لیے کون سی کتاب منتخب کی؟"; isHeading: true; isUrdu: true; animDelay: 2060 }
            AnimBlock { blockText: "تدریس کے لیے ہم نے <b><font color='#ffffff'>\"دروس اللغۃ العربیۃ\" (Duroos-ul-Lughat-il-Arabiyya)</font></b> کا انتخاب کیا ہے۔ ہم جس کتاب کا استعمال کر رہے ہیں وہ تقریباً 4 حصوں پر مشتمل ہے اور دراصل اس کی <b><font color='#ffffff'>\"شرح\"</font></b> ہے۔"; isUrdu: true; animDelay: 2180 }
            Item { width: 1; height: 20 }
            AnimBlock { blockText: "یہی کتاب کیوں؟"; isHeading: true; isUrdu: true; animDelay: 2300 }
            AnimBlock { blockText: "اس کی وجہ یہ ہے کہ اس میں بہت سی مشقیں موجود ہیں اور ساتھ ہی مشق کرنے کے لیے بہت سے الفاظ اور جملے بھی دیے گئے ہیں۔ اس کے جملے 'صرف' اور 'نحو' کے تقریباً تمام قواعد اور گرامر کا احاطہ کرتے ہیں، جس کی بدولت آپ عملی مشق کر سکتے ہیں۔"; isUrdu: true; animDelay: 2420 }
            Item { width: 1; height: 60 }
        }
    }

    DesignEffect { effects: [ DesignInnerShadow { } ] }
}
