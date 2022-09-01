#include <QCoreApplication>
#include <QFile>
#include <QDebug>
#include <QBuffer>

#define DEB_SRC "deb-src"
#define DEB_SRC_STRING DEB_SRC" "
#define DEB_STRING "deb "
#define SHELL_COMMENT "#"

int main(int, char *argv[])
{
    QString srcPath = argv[1];
    if (srcPath.isEmpty())
        qFatal("You must specify the source file.");

    QFile file(srcPath);
    if (!file.open(QFile::ReadWrite)) {
        qWarning() << "The souorce" << "[" << srcPath << "]" << " open failed.";
        return -1;
    }

    QTextStream in(&file);
    QSet<QString> debSrcOriginSet, debSrcSet;
    while (!in.atEnd()) {
        QString data = in.readLine();
        if (data.contains(DEB_SRC_STRING) && !data.startsWith(SHELL_COMMENT)) {
            debSrcOriginSet.insert(data);
        }
    }

    in.seek(0);
    while (!in.atEnd()) {
        QString data = in.readLine();
        qInfo() << "Pasing       data: " << data;
        if (data.contains(DEB_SRC_STRING) && data.startsWith(SHELL_COMMENT)) {
            data = data.mid(1);
            if (!debSrcOriginSet.contains(data)) {
                debSrcSet.insert(data);
                qInfo() << "Generate   source: " << data;
            }
        } else if (data.contains(DEB_STRING) && data.startsWith(DEB_STRING)) {
            data = data.mid(3);
            data.insert(0, DEB_SRC);
            if (!debSrcOriginSet.contains(data)) {
                debSrcSet.insert(data);
                qInfo() << "Generate from src: " << data;
            }
        }
    }

    QByteArray fileData;
    QBuffer buffer(&fileData);
    buffer.open(QBuffer::WriteOnly);
    in.setDevice(&buffer);

    for (QString debSrc : debSrcSet) {
        qInfo() << "Write      source: " << debSrc;
        Qt::endl(in) << debSrc;
        Qt::endl(in);
    }
    file.write(fileData);
    file.close();
    qInfo() << "Write source finished.";
    return 0;
}
