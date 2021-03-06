# frozen_string_literal: true

require 'spec_helper'

describe QryFilter do
  let(:controller) { Controller.new }

  before(:all) do
    User.create(id: 1, name: 'A', age: 18)
    User.create(id: 2, name: 'B', age: 19)
    User.create(id: 3, name: 'C', age: 21)

    @users = User.all

    @filter_hash = {
      id: [1, 2],
      age: [18, 21]
    }
  end

  describe '.compose' do
    it 'finds the corresponding filter class' do
      result = QryFilter.compose(
        @users,
        @filter_hash,
        filter_by: [:id]
      )

      expect(result.pluck(:id)).to eq(@filter_hash[:id])
    end

    it 'default filter when filter_by is not defined' do
      result = QryFilter.compose(
        @users,
        @filter_hash,
        filter_by: [],
        filter_class: UserFilter
      )

      expect(result.pluck(:id)).to eq([1])
    end

    it 'filters scope based on ID' do
      result = QryFilter.compose(
        @users,
        @filter_hash,
        filter_class: UserFilter,
        filter_by: [:id]
      )

      result = result.pluck(:id)

      expect(result).to eq(@filter_hash[:id])
    end

    it 'filters scope based on Age' do
      result = QryFilter.compose(
        @users,
        @filter_hash,
        filter_class: UserFilter,
        filter_by: [:age]
      )

      expect(result.pluck(:age)).to eq(@filter_hash[:age])
    end
  end

  describe '.filter' do
    it 'finds the corresponding filter class' do
      result = controller.filter User, @filter_hash, filter_by: [:id]

      expect(result.pluck(:id)).to eq(@filter_hash[:id])
    end
  end
end
