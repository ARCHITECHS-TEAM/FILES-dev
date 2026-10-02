-- CreateTable
CREATE TABLE "User" (
    "userId" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "roleId" INTEGER NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("userId")
);

-- CreateTable
CREATE TABLE "Role" (
    "roleId" SERIAL NOT NULL,
    "roleName" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "Role_pkey" PRIMARY KEY ("roleId")
);

-- CreateTable
CREATE TABLE "Permission" (
    "permissionId" SERIAL NOT NULL,
    "permissionName" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "Permission_pkey" PRIMARY KEY ("permissionId")
);

-- CreateTable
CREATE TABLE "RolePermission" (
    "roleId" INTEGER NOT NULL,
    "permissionId" INTEGER NOT NULL,

    CONSTRAINT "RolePermission_pkey" PRIMARY KEY ("roleId","permissionId")
);

-- CreateTable
CREATE TABLE "Scanner" (
    "scannerId" SERIAL NOT NULL,
    "scannerName" TEXT NOT NULL,
    "scannerSerial" TEXT NOT NULL,
    "scannerModel" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "lastConnectedAt" TIMESTAMP(3),

    CONSTRAINT "Scanner_pkey" PRIMARY KEY ("scannerId")
);

-- CreateTable
CREATE TABLE "ScanSession" (
    "sessionId" SERIAL NOT NULL,
    "scannerId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "errorMessage" TEXT,
    "retryCount" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "ScanSession_pkey" PRIMARY KEY ("sessionId")
);

-- CreateTable
CREATE TABLE "OCRResult" (
    "ocrResultId" SERIAL NOT NULL,
    "documentId" INTEGER NOT NULL,
    "extractedText" TEXT,
    "status" TEXT NOT NULL,
    "errorMessage" TEXT,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),
    "attemptNumber" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "OCRResult_pkey" PRIMARY KEY ("ocrResultId")
);

-- CreateTable
CREATE TABLE "Document" (
    "documentId" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "fileName" TEXT NOT NULL,
    "storageUrl" TEXT NOT NULL,
    "docTypeId" INTEGER NOT NULL,
    "fileType" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "fileSize" INTEGER NOT NULL,
    "pageCount" INTEGER NOT NULL DEFAULT 1,
    "createdBy" INTEGER NOT NULL,
    "lastUpdatedBy" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL,
    "ocrStatus" TEXT NOT NULL,

    CONSTRAINT "Document_pkey" PRIMARY KEY ("documentId")
);

-- CreateTable
CREATE TABLE "DocumentPage" (
    "pageId" SERIAL NOT NULL,
    "documentId" INTEGER NOT NULL,
    "scanSessionId" INTEGER,
    "pageNumber" INTEGER NOT NULL,
    "originalPath" TEXT NOT NULL,
    "processedPath" TEXT,
    "status" TEXT NOT NULL,

    CONSTRAINT "DocumentPage_pkey" PRIMARY KEY ("pageId")
);

-- CreateTable
CREATE TABLE "DocumentAccess" (
    "userId" INTEGER NOT NULL,
    "documentId" INTEGER NOT NULL,
    "accessType" TEXT NOT NULL,

    CONSTRAINT "DocumentAccess_pkey" PRIMARY KEY ("userId","documentId")
);

-- CreateTable
CREATE TABLE "QRCode" (
    "qrCodeId" SERIAL NOT NULL,
    "qrValue" TEXT NOT NULL,
    "documentId" INTEGER NOT NULL,
    "generatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "invalidatedAt" TIMESTAMP(3),

    CONSTRAINT "QRCode_pkey" PRIMARY KEY ("qrCodeId")
);

-- CreateTable
CREATE TABLE "FileConversion" (
    "conversionId" SERIAL NOT NULL,
    "documentId" INTEGER NOT NULL,
    "sourceFormat" TEXT NOT NULL,
    "targetFormat" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "outputPath" TEXT,
    "errorMessage" TEXT,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "FileConversion_pkey" PRIMARY KEY ("conversionId")
);

-- CreateTable
CREATE TABLE "DocumentType" (
    "docTypeId" SERIAL NOT NULL,
    "docTypeName" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "namingRule" TEXT NOT NULL,
    "retentionPeriod" INTEGER,

    CONSTRAINT "DocumentType_pkey" PRIMARY KEY ("docTypeId")
);

-- CreateTable
CREATE TABLE "MetadataField" (
    "fieldId" SERIAL NOT NULL,
    "docTypeId" INTEGER NOT NULL,
    "fieldName" TEXT NOT NULL,
    "fieldType" TEXT NOT NULL,
    "isRequired" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "MetadataField_pkey" PRIMARY KEY ("fieldId")
);

-- CreateTable
CREATE TABLE "DocumentMetadata" (
    "metadataId" SERIAL NOT NULL,
    "documentId" INTEGER NOT NULL,
    "fieldId" INTEGER NOT NULL,
    "fieldValue" TEXT NOT NULL,

    CONSTRAINT "DocumentMetadata_pkey" PRIMARY KEY ("metadataId")
);

-- CreateTable
CREATE TABLE "Category" (
    "categoryId" SERIAL NOT NULL,
    "categoryName" TEXT NOT NULL,
    "description" TEXT,
    "createdBy" INTEGER NOT NULL,
    "lastUpdatedBy" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUpdatedAt" TIMESTAMP(3),

    CONSTRAINT "Category_pkey" PRIMARY KEY ("categoryId")
);

-- CreateTable
CREATE TABLE "DocumentCategory" (
    "documentId" INTEGER NOT NULL,
    "categoryId" INTEGER NOT NULL,

    CONSTRAINT "DocumentCategory_pkey" PRIMARY KEY ("documentId","categoryId")
);

-- CreateTable
CREATE TABLE "Tag" (
    "tagId" SERIAL NOT NULL,
    "tagName" TEXT NOT NULL,
    "description" TEXT,
    "createdBy" INTEGER NOT NULL,
    "lastUpdatedBy" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUpdatedAt" TIMESTAMP(3),

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("tagId")
);

-- CreateTable
CREATE TABLE "DocumentTag" (
    "documentId" INTEGER NOT NULL,
    "tagId" INTEGER NOT NULL,

    CONSTRAINT "DocumentTag_pkey" PRIMARY KEY ("documentId","tagId")
);

-- CreateTable
CREATE TABLE "ActivityLog" (
    "logId" SERIAL NOT NULL,
    "userId" INTEGER,
    "documentId" INTEGER,
    "scannerId" INTEGER,
    "action" TEXT NOT NULL,
    "result" TEXT NOT NULL,
    "details" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ActivityLog_pkey" PRIMARY KEY ("logId")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Role_roleName_key" ON "Role"("roleName");

-- CreateIndex
CREATE UNIQUE INDEX "Permission_permissionName_key" ON "Permission"("permissionName");

-- CreateIndex
CREATE UNIQUE INDEX "Scanner_scannerSerial_key" ON "Scanner"("scannerSerial");

-- CreateIndex
CREATE INDEX "ScanSession_scannerId_idx" ON "ScanSession"("scannerId");

-- CreateIndex
CREATE INDEX "ScanSession_userId_idx" ON "ScanSession"("userId");

-- CreateIndex
CREATE INDEX "OCRResult_documentId_idx" ON "OCRResult"("documentId");

-- CreateIndex
CREATE UNIQUE INDEX "DocumentPage_documentId_pageNumber_key" ON "DocumentPage"("documentId", "pageNumber");

-- CreateIndex
CREATE UNIQUE INDEX "QRCode_qrValue_key" ON "QRCode"("qrValue");

-- CreateIndex
CREATE INDEX "QRCode_documentId_idx" ON "QRCode"("documentId");

-- CreateIndex
CREATE INDEX "FileConversion_documentId_idx" ON "FileConversion"("documentId");

-- CreateIndex
CREATE UNIQUE INDEX "DocumentType_docTypeName_key" ON "DocumentType"("docTypeName");

-- CreateIndex
CREATE UNIQUE INDEX "MetadataField_docTypeId_fieldName_key" ON "MetadataField"("docTypeId", "fieldName");

-- CreateIndex
CREATE UNIQUE INDEX "DocumentMetadata_documentId_fieldId_key" ON "DocumentMetadata"("documentId", "fieldId");

-- CreateIndex
CREATE UNIQUE INDEX "Category_categoryName_key" ON "Category"("categoryName");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_tagName_key" ON "Tag"("tagName");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"("roleId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RolePermission" ADD CONSTRAINT "RolePermission_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"("roleId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RolePermission" ADD CONSTRAINT "RolePermission_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "Permission"("permissionId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanSession" ADD CONSTRAINT "ScanSession_scannerId_fkey" FOREIGN KEY ("scannerId") REFERENCES "Scanner"("scannerId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanSession" ADD CONSTRAINT "ScanSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("userId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OCRResult" ADD CONSTRAINT "OCRResult_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("documentId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Document" ADD CONSTRAINT "Document_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "User"("userId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Document" ADD CONSTRAINT "Document_lastUpdatedBy_fkey" FOREIGN KEY ("lastUpdatedBy") REFERENCES "User"("userId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Document" ADD CONSTRAINT "Document_docTypeId_fkey" FOREIGN KEY ("docTypeId") REFERENCES "DocumentType"("docTypeId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentPage" ADD CONSTRAINT "DocumentPage_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("documentId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentPage" ADD CONSTRAINT "DocumentPage_scanSessionId_fkey" FOREIGN KEY ("scanSessionId") REFERENCES "ScanSession"("sessionId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentAccess" ADD CONSTRAINT "DocumentAccess_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("userId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentAccess" ADD CONSTRAINT "DocumentAccess_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("documentId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QRCode" ADD CONSTRAINT "QRCode_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("documentId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FileConversion" ADD CONSTRAINT "FileConversion_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("documentId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MetadataField" ADD CONSTRAINT "MetadataField_docTypeId_fkey" FOREIGN KEY ("docTypeId") REFERENCES "DocumentType"("docTypeId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentMetadata" ADD CONSTRAINT "DocumentMetadata_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("documentId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentMetadata" ADD CONSTRAINT "DocumentMetadata_fieldId_fkey" FOREIGN KEY ("fieldId") REFERENCES "MetadataField"("fieldId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Category" ADD CONSTRAINT "Category_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "User"("userId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Category" ADD CONSTRAINT "Category_lastUpdatedBy_fkey" FOREIGN KEY ("lastUpdatedBy") REFERENCES "User"("userId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentCategory" ADD CONSTRAINT "DocumentCategory_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("documentId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentCategory" ADD CONSTRAINT "DocumentCategory_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("categoryId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tag" ADD CONSTRAINT "Tag_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "User"("userId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tag" ADD CONSTRAINT "Tag_lastUpdatedBy_fkey" FOREIGN KEY ("lastUpdatedBy") REFERENCES "User"("userId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentTag" ADD CONSTRAINT "DocumentTag_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("documentId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentTag" ADD CONSTRAINT "DocumentTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("tagId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ActivityLog" ADD CONSTRAINT "ActivityLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("userId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ActivityLog" ADD CONSTRAINT "ActivityLog_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("documentId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ActivityLog" ADD CONSTRAINT "ActivityLog_scannerId_fkey" FOREIGN KEY ("scannerId") REFERENCES "Scanner"("scannerId") ON DELETE SET NULL ON UPDATE CASCADE;
