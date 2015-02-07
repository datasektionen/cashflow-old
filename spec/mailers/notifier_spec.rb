# encoding: utf-8
require "spec_helper"

describe Notifier do

  describe "purchases" do
    before(:all) do
      @admin = create(:person, role: "admin")
      PaperTrail.enabled = true
      PaperTrail.whodunnit = @admin.id.to_s
      @purchase = create(:purchase)
    end

    before(:each) { ActionMailer::Base.deliveries = [] }

    describe "purchase_created" do
      subject { Notifier.purchase_created(@purchase) }

      it "delivers the email" do
        subject.deliver
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sets the correct to, from, and reply addresses" do
        expect(subject.to).to       eq([ @purchase.person.email ])
        expect(subject.subject).to  eq(I18n.t("mailers.notifier.purchase_created"))
        expect(subject.cc).to       eq([ @admin.email ])
        expect(subject.reply_to).to eq([ @admin.email ])
      end

      it "renders the body correctly" do
        assert subject.body.to_s.starts_with?(
          "#{ @admin.name } har nu registrerat ditt inköp ##{@purchase.id}."
        )
      end
    end

    describe "purchase_approved" do
      subject { Notifier.purchase_approved(@purchase) }

      it "delivers the email" do
        subject.deliver
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sets the correct to, from, and reply addresses" do
        expect(subject.to).to       eq([ @purchase.person.email ])
        expect(subject.subject).to  eq(I18n.t("mailers.notifier.purchase_approved"))
        expect(subject.cc).to       eq([ @admin.email ])
        expect(subject.reply_to).to eq([ @admin.email ])
      end

      it "renders the body correctly" do
        name = @admin.name
        id = @purchase.id
        assert subject.body.to_s.starts_with?(
          "#{name} har nu registrerat ditt inköp ##{id} som godkänt."
        )
      end
    end

    describe "purchase_denied" do
      subject { Notifier.purchase_denied(@purchase) }

      it "delivers the email" do
        subject.deliver
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sets the correct to, from, and reply addresses" do
        expect(subject.to).to       eq([ @purchase.person.email ])
        expect(subject.subject).to  eq(I18n.t("mailers.notifier.purchase_denied"))
        expect(subject.cc).to       eq([ @admin.email ])
        expect(subject.reply_to).to eq([ @admin.email ])
      end

      it "renders the body correctly" do
        name = @admin.name
        id = @purchase.id
        assert subject.body.to_s.starts_with?(
          "#{name} har nu registrerat ditt inköp ##{id} som avslaget."
        )
      end
    end

    describe "purchase_paid" do
      subject { Notifier.purchase_paid(@purchase) }

      it "delivers the email" do
        subject.deliver
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "renders the body correctly" do
        name = @admin.name
        id = @purchase.id
        assert subject.body.to_s.starts_with?(
          "#{name} har nu registrerat ditt inköp ##{id} som betalt," +
          " du borde få pengarna inom några dagar."
        )
      end

      context "business_unit with email" do
        before(:all) { @purchase.business_unit.update_column(:email, "a@a.a") }

        it "sets the correct to, from, and reply addresses" do
          expect(subject.to).to       eq([ @purchase.person.email ])
          expect(subject.subject).to  eq(I18n.t("mailers.notifier.purchase_paid"))
          expect(subject.cc).to       eq([ @purchase.business_unit.email ])
          expect(subject.reply_to).to eq([ @admin.email ])
        end
      end

      context "business_unit with no email" do
        before(:all) { @purchase.business_unit.update_column(:email, "") }

        it "sets the correct to, from, and reply addresses" do
          expect(subject.to).to       eq([ @purchase.person.email ])
          expect(subject.subject).to  eq(I18n.t("mailers.notifier.purchase_paid"))
          expect(subject.cc).to       eq([ @admin.email ])
          expect(subject.reply_to).to eq([ @admin.email ])
        end
      end
    end
  end
end
