#include "dynamicplugin_plugin.h"
#include "qmlmqttclient.h"

#include <qqml.h>

void DynamicpluginPlugin::registerTypes(const char *uri)
{
    // @uri com.mycompany.qmlcomponents
    qDebug() << Q_FUNC_INFO << uri;
    mText = "not defined";
    qmlRegisterType<QmlMqttClient>(uri, 1, 0, "MqttClient");
    qmlRegisterUncreatableType<QmlMqttSubscription>(uri, 1, 0, "MqttSubscription", QLatin1String("Subscriptions are read-only"));

}

QString DynamicpluginPlugin::text() const
{
    return mText;
}

void DynamicpluginPlugin::setText(const QString & newText)
{
    mText = newText;
    emit textChanged();
}

