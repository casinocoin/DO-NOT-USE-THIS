#include "splashscreen.h"
#include "clientversion.h"
#include "util.h"

#include <QPainter>
#undef loop /* ugh, remove this when the #define loop is gone from util.h */
#include <QApplication>

SplashScreen::SplashScreen(const QPixmap &pixmap, Qt::WindowFlags f) :
    QSplashScreen(pixmap, f)
{
    // set reference point, paddings
    int paddingLeftCol1 = 140;
    int paddingLeftCol2 = 220;
    int paddingTopCol = 300;
    int line1 = 0;
    int line2 = 20;

    float fontFactor            = 1.0;

    // define text to place
    QString versionText     = QString("Version %1 ").arg(QString::fromStdString(FormatFullVersion()));
    QString copyrightText1  = QString("Copyright ") + QChar(0xA9) + QString(" 2013-%1 - ").arg(COPYRIGHT_YEAR) + QString(tr("The CasinoCoin developers"));
    QString font            = "Arial";

    // load the bitmap for writing some text over it
    QPixmap newPixmap;
    if(GetBoolArg("-testnet")) {
        newPixmap     = QPixmap(":/images/splash_testnet");
    }
    else {
        newPixmap     = QPixmap(":/images/splash");
    }

    QPainter pixPaint(&newPixmap);
    QPen pen;
    pen.setWidth(1);
    pen.setColor(Qt::black);
    pixPaint.setPen(pen);

    // draw copyright stuff
    pixPaint.setFont(QFont(font, 8*fontFactor));
    pixPaint.drawText(paddingLeftCol1,paddingTopCol+line1,copyrightText1);
    // draw version number
    pixPaint.setFont(QFont(font, 8*fontFactor));
    pixPaint.drawText(paddingLeftCol2,paddingTopCol+line2,versionText);

    pixPaint.end();

    this->setPixmap(newPixmap);
}
