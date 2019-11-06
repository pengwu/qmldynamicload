#pragma once

#include <QQmlExtensionPlugin>

class DynamicpluginPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    void registerTypes(const char *uri);

    QString text() const;
    void setText( const QString& );
signals:
    void textChanged();

private:
    QString mText;

};
