import 'package:flutter/material.dart';

class TosScreen extends StatelessWidget {
  const TosScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SIMPL TERMS OF SERVICE"),),
      body: SingleChildScrollView(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                
            children: [
              SizedBox(height: 30),
                
              hText(context, "OVERVIEW"),
                
              cText(context, "This application is operated by SIMPL. Throughout the application, the terms “we”, “us” and “our” refer to SIMPL. SIMPL offers this application, including all information, tools and services available from this application to you, the user, conditioned upon your acceptance of all terms, conditions, policies and notices stated here."),
                
              cText(context, "By visiting our application and/ or purchasing something from us, you engage in our “Service” and agree to be bound by the following terms and conditions (“Terms of Service”, “Terms”), including those additional terms and conditions and policies referenced herein and/or available by hyperlink. These Terms of Service apply  to all users of the application, including without limitation users who are browsers, vendors, customers, merchants, and/ or contributors of content."),
                
              cText(context, "Please read these Terms of Service carefully before accessing or using our application. By accessing or using any part of the application, you agree to be bound by these Terms of Service. If you do not agree to all the terms and conditions of this agreement, then you may not access the application or use any services. If these Terms of Service are considered an offer, acceptance is expressly limited to these Terms of Service."),

              cText(context, "Any new features or tools which are added to the current store shall also be subject to the Terms of Service. You can review the most current version of the Terms of Service at any time on this page. We reserve the right to update, change or replace any part of these Terms of Service by posting updates and/or changes to our application. It is your responsibility to check this page periodically for changes. Your continued use of or access to the application following the posting of any changes constitutes acceptance of those changes."),
            
              hText(context, "SECTION 1 - ONLINE APP TERMS"),

              cText(context, "By agreeing to these Terms of Service, you represent that you are at least the age of majority in your state or province of residence, or that you are the age of majority in your state or province of residence and you have given us your consent to allow any of your minor dependents to use this application."),

              cText(context, "You may not use our products for any illegal or unauthorized purpose nor may you, in the use of the Service, violate any laws in your jurisdiction (including but not limited to copyright laws)."),

              cText(context, "You must not transmit any worms or viruses or any code of a destructive nature."),

              cText(context, "A breach or violation of any of the Terms will result in an immediate termination of your Services."),

              hText(context, "SECTION 2 - GENERAL CONDITIONS"),

              cText(context, "We reserve the right to refuse service to anyone for any reason at any time."),

              cText(context, "You understand that your content (not including credit card information), may be transferred unencrypted and involve (a) transmissions over various networks; and (b) changes to conform and adapt to technical requirements of connecting networks or devices. Credit card information is always encrypted during transfer over networks."),

              cText(context, "You agree not to reproduce, duplicate, copy, sell, resell or exploit any portion of the Service, use of the Service, or access to the Service or any contact on the application through which the service is provided, without express written permission by us."),

              cText(context, "The headings used in this agreement are included for convenience only and will not limit or otherwise affect these Terms."),

              hText(context, "SECTION 3 - ACCURACY, COMPLETENESS AND TIMELINESS OF INFORMATION"),

              cText(context, "We are not responsible if information made available on this application is not accurate, complete or current. The material on this application is provided for general information only and should not be relied upon or used as the sole basis for making decisions without consulting primary, more accurate, more complete or more timely sources of information. Any reliance on the material on this application is at your own risk."),

              cText(context, "This application may contain certain historical information. Historical information, necessarily, is not current and is provided for your reference only. We reserve the right to modify the contents of this application at any time, but we have no obligation to update any information on our application. You agree that it is your responsibility to monitor changes to our application."),

              hText(context, "SECTION 4 - MODIFICATIONS TO THE SERVICE AND PRICES"),

              cText(context, "Prices for our products are subject to change without notice."),

              cText(context, "We reserve the right at any time to modify or discontinue the Service (or any part or content thereof) without notice at any time."),

              cText(context, "We shall not be liable to you or to any third-party for any modification, price change, suspension or discontinuance of the Service."),

              hText(context, "SECTION 5 - ACCURACY OF BILLING AND ACCOUNT INFORMATION"),

              cText(context, "We reserve the right to refuse any order you place with us. We may, in our sole discretion, limit or cancel quantities purchased per person, per household or per order. These restrictions may include orders placed by or under the same customer account, the same credit card, and/or orders that use the same billing and/or shipping address. In the event that we make a change to or cancel an order, we may attempt to notify you by contacting the e-mail and/or billing address/phone number provided at the time the order was made. We reserve the right to limit or prohibit orders that, in our sole judgment, appear to be placed by dealers, resellers or distributors."),

              cText(context, "You agree to provide current, complete and accurate purchase and account information for all purchases made through our application. You agree to promptly update your account and other information, including your email address and credit card numbers and expiration dates, so that we can complete your transactions and contact you as needed."),

              hText(context, "SECTION 6 - OPTIONAL TOOLS"),

              cText(context, "We may provide you with access to third-party tools over which we neither monitor nor have any control nor input."),

              cText(context, "You acknowledge and agree that we provide access to such tools ”as is” and “as available” without any warranties, representations or conditions of any kind and without any endorsement. We shall have no liability whatsoever arising from or relating to your use of optional third-party tools."),

              cText(context, "Any use by you of optional tools offered through the application is entirely at your own risk and discretion and you should ensure that you are familiar with and approve of the terms on which tools are provided by the relevant third-party provider(s)."),

              cText(context, "We may also, in the future, offer new services and/or features through the application (including, the release of new tools and resources). Such new features and/or services shall also be subject to these Terms of Service."),

              hText(context, "SECTION 7 - THIRD-PARTY LINKS"),

              cText(context, "Certain content, products and services available via our Service may include materials from third-parties."),

              cText(context, "Third-party links on this application may direct you to third-party applications that are not affiliated with us. We are not responsible for examining or evaluating the content or accuracy and we do not warrant and will not have any liability or responsibility for any third-party materials or applications, or for any other materials, products, or services of third-parties."),

              cText(context, "We are not liable for any harm or damages related to the purchase or use of goods, services, resources, content, or any other transactions made in connection with any third-party applications. Please review carefully the third-party's policies and practices and make sure you understand them before you engage in any transaction. Complaints, claims, concerns, or questions regarding third-party products should be directed to the third-party."),

              cText(context, "If, at our request, you send certain specific submissions or without a request from us you send creative ideas, suggestions, proposals, plans, or other materials, whether online, by email, by postal mail, or otherwise (collectively, 'comments'), you agree that we may, at any time, without restriction, edit, copy, publish, distribute, translate and otherwise use in any medium any comments that you forward to us. We are and shall be under no obligation (1) to maintain any comments in confidence; (2) to pay compensation for any comments; or (3) to respond to any comments."),

              cText(context, "We may, but have no obligation to, monitor, edit or remove content that we determine in our sole discretion are unlawful, offensive, threatening, libelous, defamatory, pornographic, obscene or otherwise objectionable or violates any party’s intellectual property or these Terms of Service. You agree that your comments will not violate any right of any third-party, including copyright, trademark, privacy, personality or other personal or proprietary right. You further agree that your comments will not contain libelous or otherwise unlawful, abusive or obscene material, or contain any computer virus or other malware that could in any way affect the operation of the Service or any related application. You may not use a false e-mail address, pretend to be someone other than yourself, or otherwise mislead us or third-parties as to the origin of any comments. You are solely responsible for any comments you make and their accuracy. We take no responsibility and assume no liability for any comments posted by you or any third-party."),

              hText(context, "SECTION 9 - PERSONAL INFORMATION"),

              cText(context, "Your submission of personal information through the application is governed by our Privacy Policy."),

              hText(context, "SECTION 10 - ERRORS, INACCURACIES AND OMISSIONS"),

              cText(context, "Occasionally there may be information on our application or in the Service that contains typographical errors, inaccuracies or omissions that may relate to product descriptions, pricing, promotions, offers, product shipping charges, transit times and availability. We reserve the right to correct any errors, inaccuracies or omissions, and to change or update information or cancel orders if any information in the Service or on any related application is inaccurate at any time without prior notice (including after you have submitted your order)."),

              cText(context, "We undertake no obligation to update, amend or clarify information in the Service or on any related application, including without limitation, pricing information, except as required by law. No specified update or refresh date applied in the Service or on any related application, should be taken to indicate that all information in the Service or on any related application has been modified or updated."),

              hText(context, "SECTION 11 - PROHIBITED USES"),

              cText(context, "In addition to other prohibitions as set forth in the Terms of Service, you are prohibited from using the application or its content: (a) for any unlawful purpose; (b) to solicit others to perform or participate in any unlawful acts; (c) to violate any international, federal, provincial or state regulations, rules, laws, or local ordinances; (d) to infringe upon or violate our intellectual property rights or the intellectual property rights of others; (e) to harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate based on gender, sexual orientation, religion, ethnicity, race, age, national origin, or disability; (f) to submit false or misleading information; (g) to upload or transmit viruses or any other type of malicious code that will or may be used in any way that will affect the functionality or operation of the Service or of any related application, other applications, or the Internet; (h) to collect or track the personal information of others; (i) to spam, phish, pharm, pretext, spider, crawl, or scrape; (j) for any obscene or immoral purpose; or (k) to interfere with or circumvent the security features of the Service or any related application, other applications, or the Internet. We reserve the right to terminate your use of the Service or any related application for violating any of the prohibited uses."),

              hText(context, "SECTION 12 - DISCLAIMER OF WARRANTIES; LIMITATION OF LIABILITY"),

              cText(context, "We do not guarantee, represent or warrant that your use of our service will be uninterrupted, timely, secure or error-free."),

              cText(context, "We do not warrant that the results that may be obtained from the use of the service will be accurate or reliable."),

              cText(context, "You agree that from time to time we may remove the service for indefinite periods of time or cancel the service at any time, without notice to you. You expressly agree that your use of, or inability to use, the service is at your sole risk. The service and all products and services delivered to you through the service are (except as expressly stated by us) provided 'as is' and 'as available' for your use, without any representation, warranties or conditions of any kind, either express or implied, including all implied warranties or conditions of merchantability, merchantable quality, fitness for a particular purpose, durability, title, and non-infringement."),

              cText(context, "In no case shall SIMPL, our directors, officers, employees, affiliates, agents, contractors, interns, suppliers, service providers or licensors be liable for any injury, loss, claim, or any direct, indirect, incidental, punitive, special, or consequential damages of any kind, including, without limitation lost profits, lost revenue, lost savings, loss of data, replacement costs, or any similar damages, whether based in contract, tort (including negligence), strict liability or otherwise, arising from your use of any of the service or any products procured using the service, or for any other claim related in any way to your use of the service or any product, including, but not limited to, any errors or omissions in any content, or any loss or damage of any kind incurred as a result of the use of the service or any content (or product) posted, transmitted, or otherwise made available via the service, even if advised of their possibility. Because some states or jurisdictions do not allow the exclusion or the limitation of liability for consequential or incidental damages, in such states or jurisdictions, our liability shall be limited to the maximum extent permitted by law."),

              hText(context, "SECTION 13 - INDEMNIFICATION"),

              cText(context, "You agree to indemnify, defend and hold harmless SIMPL and our parent, subsidiaries, affiliates, partners, officers, directors, agents, contractors, licensors, service providers, subcontractors, suppliers, interns and employees, harmless from any claim or demand, including reasonable attorneys’ fees, made by any third-party due to or arising out of your breach of these Terms of Service or the documents they incorporate by reference, or your violation of any law or the rights of a third-party."),

              hText(context, "SECTION 14 - SEVERABILITY"),

              cText(context, "In the event that any provision of these Terms of Service is determined to be unlawful, void or unenforceable, such provision shall nonetheless be enforceable to the fullest extent permitted by applicable law, and the unenforceable portion shall be deemed to be severed from these Terms of Service, such determination shall not affect the validity and enforceability of any other remaining provisions."),

              hText(context, "SECTION 15 - TERMINATION"),

              cText(context, "The obligations and liabilities of the parties incurred prior to the termination date shall survive the termination of this agreement for all purposes."),

              cText(context, "These Terms of Service are effective unless and until terminated by either you or us. You may terminate these Terms of Service at any time by notifying us that you no longer wish to use our Services, or when you cease using our application. If in our sole judgment you fail, or we suspect that you have failed, to comply with any term or provision of these Terms of Service, we also may terminate this agreement at any time without notice and you will remain liable for all amounts due up to and including the date of termination; and/or accordingly may deny you access to our Services (or any part thereof)."),

              hText(context, "SECTION 16 - ENTIRE AGREEMENT"),

              cText(context, "The failure of us to exercise or enforce any right or provision of these Terms of Service shall not constitute a waiver of such right or provision."),

              cText(context, "These Terms of Service and any policies or operating rules posted by us on this application or in respect to The Service constitutes the entire agreement and understanding between you and us and govern your use of the Service, superseding any prior or contemporaneous agreements, communications and proposals, whether oral or written, between you and us (including, but not limited to, any prior versions of the Terms of Service). Any ambiguities in the interpretation of these Terms of Service shall not be construed against the drafting party."),

              hText(context, "SECTION 17 - GOVERNING LAW"),

              cText(context, "These Terms of Service and any separate agreements whereby we provide you Services shall be governed by and construed in accordance with the laws of 4822 E Palmetto St, Florence, SC, 29506, United States."),

              hText(context, "SECTION 18 - CHANGES TO TERMS OF SERVICE"),

              cText(context, "You can review the most current version of the Terms of Service at any time at this page."),

              cText(context, "We reserve the right, at our sole discretion, to update, change or replace any part of these Terms of Service by posting updates and changes to our application. It is your responsibility to check our application periodically for changes. Your continued use of or access to our application or the Service following the posting of any changes to these Terms of Service constitutes acceptance of those changes"),

              hText(context, "SECTION 19 - CONTACT INFORMATION"),

              cText(context, "Questions about the Terms of Service should be sent to contact.sam.codes@gmail.com."),

            ],
                
            ),
          ),
        ),
      ),
    );
  }

  Widget cText(BuildContext context, String text) {
    return Column(
      children: [
        SizedBox(height: 10),
        Text(text, style: TextStyle( fontSize: 15, fontWeight: FontWeight.w600)),
        SizedBox(height: 10),
      ],
    );
  }

  Widget hText(BuildContext context, String text) {
    return Column(
      children: [
        SizedBox(height: 15),
        Center(child: Text(text, style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold))),
        SizedBox(height: 15),
      ],
    );
  }
}