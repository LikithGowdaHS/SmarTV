#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "application.h"

int main(int argc, char *argv[])
{
	qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

	QGuiApplication app(argc, argv);

	Application a;

	return app.exec();
}
