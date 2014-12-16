# encoding: utf-8
require 'spec_helper'

describe Notifier do

  describe "purchases" do
    before(:all) do
      @admin = Factory :person, role: 'admin'
      PaperTrail.enabled = true
      PaperTrail.whodunnit = @admin.id.to_s
      @purchase = Factory :purchase
    end

    before(:each) { ActionMailer::Base.deliveries = [] }

    describe "purchase_created" do
      subject { Notifier.purchase_created(@purchase) }

      before(:each) { subject.deliver }

      it "delivers the email" do
        subject.deliver
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "sets the correct to, from, and reply addresses" do
        subject.to.should       == [ @purchase.person.email ]
        subject.subject.should  == I18n.t('mailers.notifier.purchase_created')
        subject.cc.should       == [ @admin.email ]
        subject.reply_to.should == [ @admin.email ]
      end

      it "renders the body correctly" do
        assert subject.body.to_s.starts_with?(
          "#{ @admin.name } har nu registrerat ditt inköp ##{@purchase.id}."
        )
      end
    end

    describe "purchase_approved" do
      subject { Notifier.purchase_approved(@purchase) }

      before(:each) { subject.deliver }

      it "delivers the email" do
        subject.deliver
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "sets the correct to, from, and reply addresses" do
        subject.to.should       == [ @purchase.person.email ]
        subject.subject.should  == I18n.t('mailers.notifier.purchase_approved')
        subject.cc.should       == [ @admin.email ]
        subject.reply_to.should == [ @admin.email ]
      end

      it "renders the body correctly" do
        assert subject.body.to_s.starts_with?(
          "#{ @admin.name } har nu registrerat ditt inköp ##{@purchase.id} som godkänt."
        )
      end
    end

    describe "purchase_denied" do
      subject { Notifier.purchase_denied(@purchase) }

      before(:each) { subject.deliver }

      it "delivers the email" do
        subject.deliver
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "sets the correct to, from, and reply addresses" do
        subject.to.should       == [ @purchase.person.email ]
        subject.subject.should  == I18n.t('mailers.notifier.purchase_denied')
        subject.cc.should       == [ @admin.email ]
        subject.reply_to.should == [ @admin.email ]
      end

      it "renders the body correctly" do
        assert subject.body.to_s.starts_with?(
          "#{ @admin.name } har nu registrerat ditt inköp ##{ @purchase.id } som avslaget."
        )
      end
    end

    describe "purchase_paid" do
      subject { Notifier.purchase_paid(@purchase) }

      before(:each) { subject.deliver }

      it "delivers the email" do
        subject.deliver
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "renders the body correctly" do
        assert subject.body.to_s.starts_with?(
          "#{ @admin.name } har nu registrerat ditt inköp ##{@purchase.id} som betalt, du borde få pengarna inom några dagar."
        )
      end

      context "business_unit with email" do
        before(:all) { @purchase.business_unit.update_column(:email, "a@a.a") }

        it "sets the correct to, from, and reply addresses" do
          subject.to.should       == [ @purchase.person.email ]
          subject.subject.should  == I18n.t('mailers.notifier.purchase_paid')
          subject.cc.should       == [ @purchase.business_unit.email ]
          subject.reply_to.should == [ @admin.email ]
        end
      end

      context "business_unit with no email" do
        before(:all) { @purchase.business_unit.update_column(:email, nil) }

        it "sets the correct to, from, and reply addresses" do
          subject.to.should       == [ @purchase.person.email ]
          subject.subject.should  == I18n.t('mailers.notifier.purchase_paid')
          subject.cc.should       == [ @admin.email ]
          subject.reply_to.should == [ @admin.email ]
        end
      end
    end
  end

  describe "debts" do

    before(:all) do
      @admin = Factory :person, role: 'admin'
      PaperTrail.enabled = true
      PaperTrail.whodunnit = @admin.id.to_s
      @debt = Factory :debt
    end

    describe "debt_created" do
      subject { Notifier.debt_created(@debt) }

      before(:each) { subject.deliver }

      it "delivers the email" do
        subject.deliver
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "sets the correct to, from, and reply addresses" do
        subject.to.should       == [ @debt.person.email ]
        subject.subject.should  == I18n.t('mailers.notifier.debt_created')
        subject.cc.should       == [ @admin.email ]
        subject.reply_to.should == [ @admin.email ]
      end

      it "renders the body correctly" do
        assert subject.body.to_s.starts_with?(
          "#{ @admin.name } har registrerat att du har en skuld till Konglig Datasektionen enligt nedan:"
        )
      end
    end

    describe "debt_paid" do
      subject { Notifier.debt_paid(@debt).deliver }

      before(:each) { subject.deliver }

      it "delivers the email" do
        subject.deliver
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "sets the correct to, from, and reply addresses" do
        subject.to.should       == [ @debt.person.email ]
        subject.subject.should  == I18n.t('mailers.notifier.debt_paid')
        subject.cc.should       == [ @admin.email ]
        subject.reply_to.should == [ @admin.email ]
      end

      it "renders the body correctly" do
        assert subject.body.to_s.starts_with?(
          "#{ @admin.name } har registrerat att din skuld till Konglig Datasektionen markerats som betald."
        )
      end
    end

    describe "debt_cancelled" do
      subject { Notifier.debt_cancelled(@debt).deliver }

      before(:each) { subject.deliver }

      it "delivers the email" do
        subject.deliver
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "sets the correct to, from, and reply addresses" do
        subject.to.should       == [ @debt.person.email ]
        subject.subject.should  == I18n.t('mailers.notifier.debt_cancelled')
        subject.cc.should       == [ @admin.email ]
        subject.reply_to.should == [ @admin.email ]
      end

      it "renders the body correctly" do
        assert subject.body.to_s.starts_with?(
          "#{ @admin.name } har strukit din skuld ##{ @debt.id } till datasektionen."
        )
      end
    end
  end
end
