require 'rails_helper'

RSpec.describe Invoice do
  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchant).through(:items) }
  end

  it '#total_revenue' do
    expect(@invoice_1.total_revenue).to eq(1600)
    expect(@invoice_4.total_revenue).to eq(12480000)
  end

  describe 'models' do
    it '#incomplete_invoices' do
      expected_result = [@invoice_1, @invoice_2, @invoice_3,
                         @invoice_4, @invoice_5, @invoice_6,
                         @invoice_7, @invoice_8, @invoice_9,
                         @invoice_10, @invoice_11, @invoice_12,
                         @invoice_13, @invoice_14, @invoice_15,
                         @invoice_19, @invoice_20]

      #Expected result ordered oldest to newest

      expect(Invoice.incomplete_invoices).to eq(expected_result)
    end
  end

  describe '#total_discounted_revenue' do
    it 'applies the best discount' do
      invoice_21 = @customer_6.invoices.create!
      invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 20, unit_price: @item_4.unit_price, status: 0)

      #20 * 312 = 6240 * .7 (with 30% off 20 or more items) = 4368.00

      expect(invoice_21.total_discounted_revenue).to eq(436800)
    end

    it 'tests merchant else statement by creating merchants without discounts' do
      merchant_2 = Merchant.create!(name: "Bill")
      most_expensive_item = merchant_2.items.create!(name: "Most Expensive Item", description: "Description", unit_price: 10000000)
      super_rich_customer = Customer.create!(first_name: "Billionaire", last_name: "Person")
      new_invoice_1 = super_rich_customer.invoices.create!
      new_invoice_1.invoice_items.create!(item_id: most_expensive_item.id, quantity: 1, unit_price: most_expensive_item.unit_price, status: 1)
      new_invoice_1.transactions.create!(credit_card_number: "1111 1111 1111 1111", result: "success")

      expect(new_invoice_1.total_discounted_revenue).to eq(10000000)
    end

    it 'applies the same discount to all items that meet the quantity threshold' do
      invoice_21 = @customer_6.invoices.create!
      invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 30, unit_price: @item_4.unit_price, status: 0)
      invoice_21.invoice_items.create!(item_id: @item_5.id, quantity: 30, unit_price: @item_5.unit_price, status: 0)
      invoice_21.invoice_items.create!(item_id: @item_6.id, quantity: 30, unit_price: @item_6.unit_price, status: 0)

      expect(invoice_21.total_discounted_revenue).to eq(676800)
    end

    it 'displays full price for reference' do
      invoice_21 = @customer_6.invoices.create!
      invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 9, unit_price: @item_4.unit_price, status: 0)
      invoice_21.invoice_items.create!(item_id: @item_5.id, quantity: 9, unit_price: @item_5.unit_price, status: 0)
      invoice_21.invoice_items.create!(item_id: @item_6.id, quantity: 9, unit_price: @item_6.unit_price, status: 0)

      expect(invoice_21.total_discounted_revenue).to eq(338400)
    end

    it 'applies discount to appropriate items' do
      invoice_21 = @customer_6.invoices.create!
      invoice_21.invoice_items.create!(item_id: @item_4.id, quantity: 20, unit_price: @item_4.unit_price, status: 0)
      invoice_21.invoice_items.create!(item_id: @item_5.id, quantity: 10, unit_price: @item_5.unit_price, status: 0)

      #20 * 312 = 6240 * .7 (with 30% off 20 or more items) = 4368
      #10 * 23 = 230 * .8 (with 20% off 10 or more items) = 184
      #4368 + 184 = 4552.00

      expect(invoice_21.total_discounted_revenue).to eq(455200)
    end
  end
end
