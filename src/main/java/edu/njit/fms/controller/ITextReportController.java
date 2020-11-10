package edu.njit.fms.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import com.itextpdf.kernel.events.Event;
import com.itextpdf.kernel.events.IEventHandler;
import com.itextpdf.kernel.events.PdfDocumentEvent;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ITextReportController {
    
    @RequestMapping("itext")
    public void getReport(HttpServletResponse response) throws IOException {
        response.setContentType("application/pdf");
        // response.setHeader("Content-disposition","attachment;filename="+
        // "testPDF.pdf");
        PdfWriter writer = new PdfWriter(response.getOutputStream());
        PdfDocument pdf = new PdfDocument(writer);
        pdf.addEventHandler(PdfDocumentEvent.END_PAGE, new PDFEventHandler());
        Document document = new Document(pdf);

        document.add(new Paragraph("Hello World!"));
        document.close();
    }

    public class PDFEventHandler implements IEventHandler {

        @Override
        public void handleEvent(Event event) {
            // TODO Auto-generated method stub

        }
        
    }
}