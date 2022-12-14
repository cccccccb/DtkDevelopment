/*
    SPDX-FileCopyrightText: 2020 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
*/

#ifndef WAYLAND_SERVER_ABSTRACT_DATA_SOURCE_H
#define WAYLAND_SERVER_ABSTRACT_DATA_SOURCE_H

#include "clientconnection.h"
#include "datadevicemanager_interface.h"

#include <KWayland/Server/kwaylandserver_export.h>
#include "resource.h"

struct wl_client;

namespace KWayland
{

namespace Server
{
/**
 * @brief The AbstractDataSource class abstracts the data that
 * can be transferred to another client.
 *
 * It loosely maps to DataDeviceInterface
 */

// Anything related to selections are pure virtual, content relating
// to drag and drop has a default implementation

class KWAYLANDSERVER_EXPORT AbstractDataSource : public Resource
{
    Q_OBJECT
public:
    virtual bool isAccepted() const
    {
        return false;
    }

    virtual void accept(const QString &mimeType)
    {
        Q_UNUSED(mimeType);
    };
    virtual void requestData(const QString &mimeType, qint32 fd) = 0;
    virtual void cancel() = 0;

    virtual QStringList mimeTypes() const = 0;

    /**
     * @returns The Drag and Drop actions supported by this DataSourceInterface.
     */
    virtual DataDeviceManagerInterface::DnDActions supportedDragAndDropActions() const
    {
        return {};
    };
    /**
     * The user performed the drop action during a drag and drop operation.
     */
    virtual void dropPerformed(){};
    /**
     * The drop destination finished interoperating with this data source.
     */
    virtual void dndFinished(){};
    /**
     * This event indicates the @p action selected by the compositor after matching the
     * source/destination side actions. Only one action (or none) will be offered here.
     */
    virtual void dndAction(DataDeviceManagerInterface::DnDAction action)
    {
        Q_UNUSED(action);
    };

    /**
     *  Called when a user stops clicking but it is not accepted by a client.
     */
    virtual void dndCancelled()
    {
    }

    /*virtual wl_client *client() const
    {
        return nullptr;
    };*/

Q_SIGNALS:
    void aboutToBeDestroyed();

    void mimeTypeOffered(const QString &);
    void supportedDragAndDropActionsChanged();

protected:
    explicit AbstractDataSource(Private *d, QObject *parent = nullptr);
};

}
}

#endif
